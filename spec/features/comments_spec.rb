require "rails_helper"

RSpec.feature "Comment", type: :feature do
  let(:user) { User.create(email: "example@gmail.com", password: "password", name: "Asia") }
  let(:genre) { Genre.create }
  let(:movie) { Movie.create(genre_id: genre.id) }

  before(:each) do
    visit user_session_path

    fill_in "Email", with: "example@gmail.com"
    fill_in "Password", with: "password"

    user.confirm

    click_button "Log in"
  end

  describe "valid comment" do
    context "with valid parameters" do
      it "will create a comment" do
        visit "/movies/#{movie.id}"

        find("#comment_title", visible: false).set "Title"
        find("#comment_body", visible: false).set "Body"
        click_button "Add comment"

        expect(page).to have_content("Comment was succesfully created.")
      end
    end

    context "after destroying previous comment" do
      let!(:comment) { Comment.create(title: "title", body: "body", movie_id: movie.id, user_id: user.id) }

      it "will create a comment" do
        visit "/movies/#{movie.id}"

        click_link "Delete"
        find("#comment_title", visible: false).set "Title"
        find("#comment_body", visible: false).set "Body"
        click_button "Add comment"

        expect(page).to have_content("Comment was succesfully created.")
      end
    end
  end

  describe "Invalid comment" do
    context "without text" do
      it "will not be created" do
        visit "/movies/#{movie.id}"

        find("#comment_title", visible: false).set "Title"
        click_button "Add comment"

        expect(page).not_to have_content("You must add body to comment")
      end
    end

    context "with another comment existing" do
      let!(:comment) { Comment.create(title: "title", body: "body", movie_id: movie.id, user_id: user.id) }

      it "will not create a comment" do
        visit "/movies/#{movie.id}"

        find("#comment_title", visible: false).set "Title"
        find("#comment_body", visible: false).set "Body"
        click_button "Add comment"

        expect(page).to have_content("Movie can be commented only once!")
      end
    end
  end

  describe "#top_commenters" do
    let(:user2) { User.create(email: "user2@gmail.com", password: "password", name: "Kasia") }
    let(:movie2) { Movie.create(genre_id: genre.id) }
    let!(:comment) { Comment.create(title: "title", body: "body", movie_id: movie.id, user_id: user2.id) }
    let!(:comment2) { Comment.create(title: "title", body: "body", movie_id: movie2.id, user_id: user2.id) }
    let!(:comment3) { Comment.create(title: "title", body: "body", movie_id: movie.id, user_id: user.id) }

    it "will display proper order" do
      visit top_commenters_path
      print page.html
      within(:xpath, "/html/body/main/div/table/tbody/tr[2]") do
        expect(page).to have_content('Kasia')
      end

      within(:xpath, "/html/body/main/div/table/tbody/tr[3]") do
        expect(page).to have_content('Asia')
      end
    end
  end
end
