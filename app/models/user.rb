class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :time_zone
  
  has_many :connections,dependent: :destroy
  has_many :posts, dependent: :destroy

  def twitter
  	self.connections.where(provider: "twitter")
  end
end
