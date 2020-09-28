# frozen_string_literal: true

# TODO: Check if it is necessary when OrderV2 model become the main model
FactoryBot.define do
  factory :user, class: User do
    uuid { SecureRandom.uuid }
    name { 'Letícia' }
    profile { :admin }
    registration { '2017200024537' }
    email { 'lepfalt@gmail.com' }
    password { '' }
  end

#   factory :thundercats_sdk_promotion_eligibility_for_order_v2_hash, class: Hash do
#     msisdn { '21993218718' }
#     recipient { '00000000000' }
#     reload_price { 1300 }
#     reload_uuid { SecureRandom.uuid }
#     payment_price { 1300 }
#     payment_source_type { 'CREDIT' }
#     service_provider_id { 'vivo' }
#     client_realm_id { 'vivo_recarga' }
#     application_id { 'VIVO_WEB' }
#     customer_id { SecureRandom.uuid }

#     initialize_with { attributes }
#   end
end
