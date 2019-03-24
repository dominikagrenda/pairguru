require "rails_helper"

 RSpec.describe Comment, type: :model do
  let!(:title) { "Comment title" }
  let!(:body) { "Comment body" }
  let!(:movie) { Movie.new(title: "Movie title") }
  let!(:movie_2) { Movie.new(title: "Movie title") }
  let!(:user) { User.new(email: "example@mail.com", password: "password") }

  subject { Comment.new(title: title, body: body, movie: movie, user: user) }

  context "without data" do
    it "is not valid without a title" do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a text" do
      subject.body = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without movie_id" do
      subject.movie = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without user_id" do
      subject.user = nil

      expect(subject).to_not be_valid
    end
  end

  context "for the same movie" do
    it "is not valid" do
        subject.save
        comment = Comment.new(title: title, body: body, movie: movie, user: user)

        expect(comment).to_not be_valid
    end
  end
end