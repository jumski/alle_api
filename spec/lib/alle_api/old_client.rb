
context 'when #request raises invalid version key error' do
  let(:message) {
    '(ERR_INVALID_VERSION_CAT_SELL_FIELDS) ' +
      'Niepoprawna wersja kategorii lub pól sprzedaży. ' +
      'Proszę sprawdzić lokalne wersje i uaktualnić oprogramowanie!'
  }

  it 'intercepts risen error' do
    subject.stubs(:authenticate!).
           raises(Savon::Error, message).
           then.returns(authenticate_result)
    subject.stubs(:update_version_key)

    expect { subject.session_handle }.to_not raise_error
  end

  it 'calls #update_version_key' do
    subject.stubs(:authenticate!).
             raises(Savon::Error, message).
           then.returns(authenticate_result)
    subject.expects(:update_version_key)

    subject.session_handle
  end

  it 'calls #authenticate! again' do
    subject.expects(:authenticate!).times(2).
             raises(Savon::Error, message).
             then.returns(authenticate_result)
    subject.stubs(:update_version_key)

    subject.session_handle
  end
end


describe '#update_version_key' do
  let(:expected_request_body) do
    { 'sysvar'     => 1,
      'country-id' => country_code,
      'webapi-key' => webapi_key }
  end

  let(:info) { "1.0.0" }
  let(:returned_version_key) { "89962559" }

  let(:expected_return_result) do
    hash = {
      do_query_sys_status_response: {
        info: info,
        ver_key: returned_version_key
      },
      :"@soap_env:encoding_style" => "http://schemas.xmlsoap.org/soap/encoding/"
    }
    stub(to_hash: hash)
  end

  it 'calls #request with proper values' do
    subject.expects(:request).
           with(:do_query_sys_status, body: expected_request_body).
           returns(expected_return_result)

    subject.update_version_key
  end

  it 'extracts version_key and sets it on client' do
    subject.stubs(:request).returns(expected_return_result)
    subject.expects(:version_key=).with(returned_version_key.to_i)

    subject.update_version_key
  end
end



def update_version_key
  results = request :do_query_sys_status,
                    body: body_for_do_query_sys_status

  version_key = results.to_hash[:do_query_sys_status_response][:ver_key].to_i
  self.version_key = version_key
end

