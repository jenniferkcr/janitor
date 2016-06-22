defmodule Janitor.DBHelpersSpec do 
  use ESpec.Phoenix, model: Janitor.DBHelpers
  alias Janitor.User
  alias Janitor.DBHelpers
  import Ecto.Query
  import Janitor.UserFactory

  let :changeset, do: User.registration_changeset(%User{}, fields_for(:user))

  describe ".find_or_create" do 
    context "when user is not in the database" do
      subject! do: DBHelpers.find_or_create_by(User, changeset, :google_id)
      
      it "inserts user to DB" do 
        query = from(p in User, select: count(p.id))
        expect(Repo.one(query)).to eq 1
      end 

      it "returns new user" do
        {:ok, user} = subject
        expect(user.id).to_not eq nil
      end 
    end 

    context "when user is already in DB" do 
      subject do: DBHelpers.find_or_create_by(User, changeset, :google_id)
      let! :user, do: DBHelpers.find_or_create_by(User, changeset, :google_id)

      it "returns the user" do
        {:ok, user} = subject
        expect(user.id).to eq user.id
      end 

      it "does not change count of objects" do 
        subject
        query = from(p in User, select: count(p.id))
        expect(Repo.one(query)).to eq 1
      end 
    end 
  end 
end 