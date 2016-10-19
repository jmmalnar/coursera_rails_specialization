class Profile < ActiveRecord::Base
  belongs_to :user

  validates :gender, inclusion: { in: %w(male female),
                                message: "%{value} is not a valid gender" }

  validate :names_not_nil

  validate :boy_named_sue?

  def names_not_nil
    if last_name.nil? and first_name.nil?
      errors.add(:last_name, 'You must input either your first or last name.  Both cannot be blank.')
    end
  end

  def boy_named_sue?
    if first_name == 'Sue' and gender == 'male'
      errors.add(:first_name, 'A boy cannot be named Sue.')
    end
  end

  def self.get_all_profiles(min_birth_year, max_birth_year)
    Profile.where("birth_year BETWEEN ? and ?", min_birth_year, max_birth_year).order(:birth_year)
  end
end
