
module SavonMacros
  def expects_request(opts)
    api.expects(:request)
       .with(opts[:action], body: opts[:body])
       .returns(stub_response(opts))
  end

  def stub_response(opts)
    response_key = :"#{opts[:action]}_response"
    stub(to_hash: { response_key => opts[:returns] })
  end
end
