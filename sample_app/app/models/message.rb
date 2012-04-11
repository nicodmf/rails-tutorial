# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  content     :string(255)
#  user_id     :integer
#  receiver_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Message < ActiveRecord::Base
  attr_accessor :receiver
  attr_accessible :content, :receiver
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :receiver, :presence => true

  belongs_to :user
  belongs_to :receiver, :class_name => "User"

  scope :received_by, lambda { |user| _received_by(user) }
  
  before_save :take_receiver

  private

    def self._received_by(receiver)
      where("receiver_id = :receiver_id", { :receiver_id => receiver })
    end
    
    def take_receiver
      self.receiver_id = receiver.id
    end
  
end
