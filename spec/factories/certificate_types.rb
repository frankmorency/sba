FactoryBot.define do
  factory :certificate_type do
    name "wosb"
    type 'CertificateType::Wosb'
    title "Women Owned Small Business"
    duration_in_days  365
  end

  factory :wosb_cert, class: CertificateType do
    name "wosb"
    type 'CertificateType::Wosb'
    title "Women Owned Self Business"
    duration_in_days  365
  end

  factory :ami_cert, class: CertificateType do
    name "ami"
    type 'CertificateType::Wosb'
    title "Am I Eligible"
    duration_in_days  365
  end

  factory :mpp_cert, class: CertificateType do
    name "mpp"
    type 'CertificateType::MPP'
    title "MPP"
    duration_in_days  365
  end

  factory :edwosb_cert, class: CertificateType do
    name "edwosb"
    type 'CertificateType::Edwosb'
    title "Women Owned Self Business"
    duration_in_days  365
  end

  factory :dynamic_cert, class: CertificateType do
    name "dyanmic"
    type 'CertificateType::Edwosb'
    title "Dynamic Certificate Type"
    duration_in_days  365
  end

  factory :basic_cert, class: CertificateType do
    name "basic"
    title "Basic Certificate Type"
    type 'CertificateType::Wosb'
    duration_in_days  365
  end

  factory :eight_a_cert_type, class: CertificateType do
    name "eight_a"
    type 'CertificateType::EightA'
    title "Eight A"
    duration_in_days 3286
  end
end
