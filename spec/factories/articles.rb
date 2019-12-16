FactoryBot.define do
  factory :article do
    user nil
    team nil
    title { "MyString" }
    content { "MyString" }
  end
end
