FactoryBot.define do
  factory :video do
    wistia_hash { 'abc123' }
    title { 'Sample Video' }
    description { 'This is a sample video.' }
    play_count { 0 }
    visible { false }
  end
end
