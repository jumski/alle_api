if respond_to? :shared_context
  shared_context 'fields' do
    let(:field_hash_a) do
      {
        sell_form_id: "2",
        sell_form_title: "Nazwa przedmiotu 2",
        sell_form_cat: "1",
        sell_form_type: "2",
        sell_form_res_type: "2",
        sell_form_def_value: "1",
        sell_form_opt: "2",
        sell_form_pos: "1",
        sell_form_length: "51",
        sell_min_value: "0.01",
        sell_max_value: "0.02",
        sell_form_desc: {"@xsi:type" => "xsd:string"},
        sell_form_opts_values: {"@xsi:type" => "xsd:string"},
        sell_form_field_desc: "description 2",
        sell_form_param_id: "1",
        sell_form_param_values: {"@xsi:type" => "xsd:string"},
        sell_form_parent_id: "3",
        sell_form_parent_value: {"@xsi:type" => "xsd:string"},
        sell_form_unit: {"@xsi:type" => "xsd:string"},
        sell_form_options: "1",
        "@xsi:type" => "typens:SellFormType"
      }
    end

    let(:field_hash_b) do
      {
        sell_form_id: "1",
        sell_form_title: "Nazwa przedmiotu",
        sell_form_cat: "0",
        sell_form_type: "1",
        sell_form_res_type: "1",
        sell_form_def_value: "0",
        sell_form_opt: "1",
        sell_form_pos: "0",
        sell_form_length: "50",
        sell_min_value: "0.00",
        sell_max_value: "0.00",
        sell_form_desc: {"@xsi:type" => "xsd:string"},
        sell_form_opts_values: {"@xsi:type" => "xsd:string"},
        sell_form_field_desc: "description",
        sell_form_param_id: "0",
        sell_form_param_values: {"@xsi:type" => "xsd:string"},
        sell_form_parent_id: "0",
        sell_form_parent_value: {"@xsi:type" => "xsd:string"},
        sell_form_unit: {"@xsi:type" => "xsd:string"},
        sell_form_options: "0",
        "@xsi:type" => "typens:SellFormType"
      }
    end
  end
end
