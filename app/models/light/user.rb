module Light
  class User
    include Mongoid::Document

    field :email_id,      type: String
    field :username,      type: String
    field :is_subscribed, type: Boolean
    field :joined_on,     type: Date
    field :source,        type: String
    field :sent_on,       type: Array

    validates :email_id, presence: true
    validates_format_of :email_id, with: /\A[a-z0-9]+([\w.+-]*[a-z0-9])*@([a-z]+[\w-]*\.)+[a-z]+\Z/i, on: :create
    validates :username, presence: true
    validates :email_id, uniqueness: true

    belongs_to :newsletter, counter_cache: :users_count

    def self.add_users_from_worksheet(worksheet, column = 1)
      fails = []

    worksheet.rows.count.times do |i|
      user = User.new(
          email_id:       worksheet[i + 1, column],
          username:       worksheet[i + 1, column - 1],
          is_subscribed:  true,
          joined_on:      Date.today,
          source:         'Google Spreadsheet')

      if user.save
      else
        fails << worksheet[i + 1, column]
      end
    end
    fails.delete_at(0)
    fails
  end
end
end
