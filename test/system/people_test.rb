require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  setup do
    @person = people(:one)
  end

  test "visiting the index" do
    visit people_url
    assert_selector "h1", text: "People"
  end

  test "creating a Person" do
    visit people_url
    click_on "New Person"

    fill_in "Birthday", with: @person.birthday
    fill_in "Body temperature", with: @person.body_temperature
    check "Can send email" if @person.can_send_email
    fill_in "Country", with: @person.country
    fill_in "Description", with: @person.description
    fill_in "Email", with: @person.email
    fill_in "Favorite time", with: @person.favorite_time
    fill_in "Graduation year", with: @person.graduation_year
    fill_in "Name", with: @person.name
    fill_in "Price", with: @person.price
    fill_in "Secret", with: @person.secret
    click_on "Create Person"

    assert_text "Person was successfully created"
    click_on "Back"
  end

  test "updating a Person" do
    visit people_url
    click_on "Edit", match: :first

    fill_in "Birthday", with: @person.birthday
    fill_in "Body temperature", with: @person.body_temperature
    check "Can send email" if @person.can_send_email
    fill_in "Country", with: @person.country
    fill_in "Description", with: @person.description
    fill_in "Email", with: @person.email
    fill_in "Favorite time", with: @person.favorite_time
    fill_in "Graduation year", with: @person.graduation_year
    fill_in "Name", with: @person.name
    fill_in "Price", with: @person.price
    fill_in "Secret", with: @person.secret
    click_on "Update Person"

    assert_text "Person was successfully updated"
    click_on "Back"
  end

  test "destroying a Person" do
    visit people_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Person was successfully destroyed"
  end
end
