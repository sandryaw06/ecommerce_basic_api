begin	
  control.algorithm("core_helper").run([control, params])	
  source_ns = control.infer_namespace_from_system(params[:_source])	
  provider_ns = control.infer_namespace_from_system(params[:_provider])	
  #connector_ns = "#{source_ns} - #{provider_ns}"	
  #connector_ns = provider_ns	
  pApp = Cenit.namespace("Payment").application('Payment')
  if pApp.id.eql?(params[:_keytoken])
    Cenit.fail("Invalid Authentication Token sent")
  end
  excludeParams = ["_source", "_provider", "_keytoken"]	
  newParams = params.select { |key, _| !excludeParams.include? key }	
  queryParams = newParams.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")	
  pAppSlug = pApp.slug_id
  params["currentURL"] = "#{Cenit.homepage}/app/#{pAppSlug}/#{params["_source"]}/#{params["_provider"]}/#{params["_keytoken"]}/payment_confirmation?#{queryParams}"	
  

  allowed_operations = %w[initialize_payment process_payment cancel_payment iframe_communicator layout payment_detail payment_list payment_list_api initialize_payment_email payment_confirmation cancel_payment payment_error]	
 operation = params[:_operation]	
  Cenit.fail "[405] - Operation '#{operation}' is not allowed." unless allowed_operations.include? operation	
  # Try detect a algorithm in charge of processing the request	
  if operation == 'layout'	
    control.render html: control.render_template('Payment Form Layout')	
  else	
    if operation.eql?("initialize_payment_email") || operation.eql?("payment_detail") || operation.eql?("payment_list") || operation.eql?("payment_list_api") || operation.eql?("payment_detail_api")	
      alg = control.algorithm(operation, false)	
    else         	
      alg = control.algorithm("#{provider_ns}::#{operation}", false)	
      if alg.nil?	
        alg = control.algorithm("#{provider_ns}::#{operation}_online", false)	
      end	
    end    	
    Cenit.fail "[501] - Operation '#{operation}' is not implemented for the provider: '#{provider_ns}'." if alg.nil?	
    if operation.eql?("initialize_payment_email")	
      # build the payment URL    	
      params["paymentLink"] = "#{Cenit.homepage}/app/#{pAppSlug}/#{params["_source"]}/#{params["_provider"]}/#{params["_keytoken"]}/initialize_payment?amount=#{params["amount"]}&referenceId=#{params["referenceId"]}"	
     end	
    # if Accela translate the Accela input parameters to the Payment SDK standard set	
    if params["_source"].eql?("accela") || params["_source"].eql?("cityworks") and params["_operation"].eql?("initialize_payment")	
      params["referenceId"] = params["TransactionID"]	
      params["amount"] = params["PaymentAmount"]	
      params["email"] = params["UserEmail"]	
    end	
    # if initalize_payment then setup the Payment object for the transaction	
    if params["_operation"].eql?("initialize_payment")	
      if params["referenceId"].nil?	
        Cenit.fail("Parameter referenceId is required")	
      end	
      payment = {}	
      payment["referenceId"] = params["referenceId"]	
      payment["transactionStatus"] = "Pending Payment"	
      payment["transactionData"] = params	
      payment = save_payment(payment)	
      params["payment"] = payment	
    end	
    #exclude_params = %w[app_slug path app _source _provider _operation _token]	
    exclude_params = %w[access_key access_token X-Tenant-Access-Key X-Tenant-Access-Token]	
    #params.merge!(control.controller.headers)	
    resp = alg.run([params.select { |param| !exclude_params.include? param }])	
    resp.deep_stringify_keys!	
    case resp['action']	
    when 'render'	
      resp['data'] = parse_url_fields(resp['data']) if resp['data']	
      control.render html: control.render_template(	
        resp['template'], resp['data']	
        )	
    when 'return'	
      control.render json: resp['data'].to_json, status: resp['code'] || 200	
    when 'redirect'	
      control.redirect_to resp['redirect_to']	
    else	
      control.fail "[406] - Only Render, Return and Redirect actions are allowed"	
    end	
  end	
rescue StandardError => ex	
  code = ex.message =~ /^\[(\d+)\]/ ? $1.to_i : 500	
  message = ex.message.gsub(/^\[(\d+)\] - /, '')	
  control.render json: { message: message }, status: code	
end
            