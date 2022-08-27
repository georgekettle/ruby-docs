class Version < ApplicationRecord
	default_scope { order(number: :desc) }
	has_many :klasses, dependent: :destroy
	validates :number, presence: true
end
