# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthday         :date
#  body_temperature :float
#  can_send_email   :boolean
#  country          :string
#  description      :text
#  email            :string
#  extension        :string
#  favorite_time    :time
#  graduation_year  :integer
#  name             :string
#  price            :decimal(, )
#  secret           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Person < ApplicationRecord

  after_save :store_photo
  # validates_presence_of :birthday, :body_temperature, :can_send_email, :country, :description, :email, :favorite_time, :graduation_year, :name, :price, :secret
  validates_presence_of :secret, message: "we need a secret so we can tell it's you next time"
  validates_length_of :secret, in: 6..24, message: "secrets must be between 6 and 24 characters"
  validates_format_of :secret, with: /[0-9]/, message: "must contain at least one number"
  validates_format_of :secret, with: /[A-Z]/, message: "must contain at least one uppercase letter"
  validates_format_of :secret, with: /[a-z]/, message: "must contain at least one lowercase letter"

  validates_inclusion_of :country, in: ['Canada', 'Mexico', 'UK', 'USA', 'China'], message: "Country must be one of: Canada, Mexico, UK, USA, or China"

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "that doesn't look like a proper e mail"
  # \A => beginning of a string
  # ([^@\s]+) => I think it means something that is NOT the '@' symbol or whitespace
  # + => "greedy" meaning, I think, every character before the @ has to fit this constraint
  # @ => there needs to be an @ symbol
  # ((?:[-a-z0-9]+\.)+[a-z]{2,})
  # (?:[-a-z0-9]+\.) AND THEN [a-z]{2,}
  # the first part: ?: is a "non capturing group" so I think it's saying we don't really care what comes after the @ as long as there's a '.'??
  # {2,} means "2 or more times" meaning after the '.' we need at least 2 lowerchase chars
  # /Z means end of string
  # the trailing i means case insensitive
  validates_uniqueness_of :email, case_sensitive: false, scope: [:name, :secret], message: "you can't sign in twice"
  # this says "hey, you can't provide the same e mail IN CONJUNCTION WITH name and secret, cause that's the SAME PERSON"
  # that said, I would still like to not allow the same e mail to be used twice, so I think a sep validation?
  # EG validates_uniqueness_of :email, message: "looks like that e mail has been used before"
  validates_numericality_of :graduation_year, allow_nil: true, greater_than: 1920, less_than_or_equal_to: Time.now.year, only_integers: true
  validates_numericality_of :body_temperature, allow_nil: true, greater_than: 70, less_than: 110, only_integers: false
  validates_numericality_of :price, allow_nil: true, greater_than_or_equal_to: 0, only_integers: false
  validates_inclusion_of :birthday, in: Date.civil(1900, 1, 1)..Date.today, message: "Birthday must be between Jan 1, 1900 and today"
  validates_presence_of :favorite_time

  validates_presence_of :description, if: :require_description?, message: "If you want to receive an email, we need a description"

  validate :description_length_words

  def require_description?
    self.can_send_email
  end

  def description_length_words
    unless self.description.blank?
      num_words = self.description.split.length
      if num_words < 5
        self.errors.add(:description, "Description must be at least 5 words")
      elsif num_words > 100
        self.errors.add(:description, "Description must not have more than 100 words")
      end
    end
  end

  def photo=(file_data)
    # I think this is basically hijacking
    # the person.photo= call??
    unless file_data.blank?
      @file_data = file_data

      self.extension = file_data.original_filename.split('.').last.downcase
    end
  end
  
  PHOTO_STORE = File.join Rails.root, 'public', 'photo_store'

  def photo_filename
    # what are we gonna call the photo?
    File.join PHOTO_STORE, "#{id}.#{extension}"
    # notice that we are not naming the photo
    # based on what came in from params,
    # but based on the id of the person
  end

  def photo_path
    "/photo_store/#{id}.#{extension}"
    # ? this seens redundant with the above
    # ? filename method??
    # photo_filename is used to save the file
    # the path is used to access it in a link
  end
  
  def has_photo?
    File.exists? photo_filename
    # this will be called by the controller?
    # returns true if such a file exists
  end

  private
    
  def store_photo
    # stores a photo passed via params
    # ? how does it save the extension??
    # ^^ within photo=
    if @file_data
      FileUtils.mkdir_p PHOTO_STORE #def'd above
      File.open(photo_filename, 'wb') do |f|
        f.write(@file_data.read)
      end
      @file_data=nil
      # to avoid repetition
    end
  end
  
end