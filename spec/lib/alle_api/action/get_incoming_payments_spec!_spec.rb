require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetIncomingPayments do

  include_examples 'api action', :do_get_my_incoming_payments do
    let(:actual_body) { subject.request_body(starting_point) }

    context 'when starting point is provided' do
      let(:starting_point) { 123 }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          # session-handle | string | wymagany
          # Identyfikator sesji użytkownika, uzyskany za pomocą metody doLogin(Enc).
          # buyer-id | int | niewymagany
          # Identyfikator kupującego, którego wpłaty mają zostać pobrane.
          # item-id | long | niewymagany
          # Identyfikator oferty, której dotyczy dana wpłata (także, gdy dana oferta jest częścią wpłaty łącznej).
          # trans-recv-date-from | long | niewymagany
          # Data początkowa zakresu czasu (w formacie Unix time), od którego ma zostać pobrana lista wpłat.
          # trans-recv-date-to | long | niewymagany
          # Data końcowa zakresu czasu (w formacie Unix time), do którego ma zostać pobrana lista wpłat.
          # trans-page-limit | int | niewymagany
          # Rozmiar porcji danych (zakres 1-25, domyślnie: 25).
          # trans-offset | int | niewymagany
          # Sterowanie (poprzez inkrementację przekazywanej wartości) pobieraniem kolejnych porcji danych (numery porcji indeksowane są od 0).
          # { 'session-id' => client.session_handle,
          #   'journal-start' => 123 }
        end
      end
    end

    context 'when starting point is not provided' do
      let(:starting_point) { nil }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          { 'session-id' => client.session_handle,
            'journal-start' => starting_point }
        end
      end
    end

    describe "uses wrapper", vcr: 'get_deals_journal' do
      include_context 'real api client'

      before do
        account.utility = true
        account.save!
        AlleApi::Helper::Versions.new.update(:version_key)
        AlleApi::Job::Authenticate.new.perform(account.id)
        @wrapped = api.get_deals_journal
      end

      context "wraps new deal event" do
        subject { @wrapped[0] }

        it { should be_a AlleApi::Wrapper::DealEvent }
        its(:remote_id) { should eq 775599262 }
        its(:model_klass) { should eq AlleApi::DealEvent::NewDeal }
        its(:occured_at) { should eq Time.at 1369042031 }
        its(:remote_deal_id) { should eq 896009896 }
        its(:remote_transaction_id) { should eq 0 }
        its(:remote_seller_id) { should eq 2783112 }
        its(:remote_auction_id) { should eq 3263045863 }
        its(:remote_buyer_id) { should eq 5697909 }
        its(:quantity) { should eq 1 }
      end

      context "wraps new transaction event" do
        subject { @wrapped[1] }

        it { should be_a AlleApi::Wrapper::DealEvent }
        its(:remote_id) { should eq 775601305 }
        its(:model_klass) { should eq AlleApi::DealEvent::NewTransaction }
        its(:occured_at) { should eq Time.at 1369042118 }
        its(:remote_deal_id) { should eq 896009896 }
        its(:remote_transaction_id) { should eq 243241703 }
        its(:remote_seller_id) { should eq 2783112 }
        its(:remote_auction_id) { should eq 3263045863 }
        its(:remote_buyer_id) { should eq 5697909 }
        its(:quantity) { should eq 1 }
      end
    end

  end

end
