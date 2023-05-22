# == Schema Information
#
# Table name: texts
#
#  id         :integer          not null, primary key
#  title      :string
#  link       :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Text < ApplicationRecord
  def words
    body.split(',').join(' ') # .split('.').join(' ').split(' ').collect(&:downcase)
        .gsub(/(\.|\,)/, ' ')
        .split
        .collect(&:downcase)
  end

  def counts
    hash = {}
    words.sort.reverse.each do |word|
      hash[word] = 0 if hash[word].nil?
      hash[word] += 1
    end

    hash.to_a.sort { |a, b| a.second <=> b.second }.reverse
  end
end
