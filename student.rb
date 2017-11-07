# Model
class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :segment
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :external_user_id, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :native_language, presence: true

  extend Enumerize
  STAUS = {
    approved: 1,
    pending: 0
  }
  enumerize :status, in: STAUS
  after_create :create_voxy_user
  after_update :update_voxy_user


  def self.sendMessage(msg, sender_id, name, phone_number)

  def self.update_level_user(id, level)
    data = {
      level: level
    }
    voxy = VoxyService.new(data)
    c = voxy.update_user(id)
  end

  def create_voxy_user

    if self.status.value.to_i == 1
      level = self.level.to_i == 0 ? 1 : self.level.to_i

      data = {
        "external_user_id": self.external_user_id,
        "first_name": self.first_name,
        "email_address": self.email,
        "native_language": 'vi',
        "expiration_date": self.expiration_date,
        "date_of_next_vpa": self.date_of_next_vpa,
        "tutoring_credits": self.tutoring_credits,

        "level": level,
        "can_reserve_group_sessions": true
      }

      voxy = VoxyService.new(data)

      c = voxy.create_user(external_user_id)

    end
  end

  def update_voxy_user
    if self.status.value.to_i == 1
      data = {
        "first_name": self.first_name,
        "email_address": self.email,
        "native_language": self.native_language,
        "expiration_date": self.expiration_date,
        "date_of_next_vpa": self.date_of_next_vpa,
        "tutoring_credits": self.tutoring_credits,
        "level": self.level,
        "can_reserve_group_sessions": true
      }

      voxy = VoxyService.new(data)
      user = voxy.get_user(self.external_user_id)

      if  user["error_message"].present?
        new_data = {
          "first_name": self.first_name,
          "email_address": self.email,
          "native_language": self.native_language,
          "expiration_date": self.expiration_date,
          "date_of_next_vpa": self.date_of_next_vpa,
          "tutoring_credits": self.tutoring_credits,
          "level": level,
          "can_reserve_group_sessions": true,
          "external_user_id": self.external_user_id
        }
        VoxyService.new(new_data).create_user(self.external_user_id)
      else
        VoxyService.new(data).update_user(self.external_user_id)
      end
    end
  end
end
