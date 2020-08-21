require "application_system_test_case"

class ClassGroupsTest < ApplicationSystemTestCase
  setup do
    @class_group = class_groups(:one)
  end

  test "visiting the index" do
    visit class_groups_url
    assert_selector "h1", text: "Class Groups"
  end

  test "creating a Class group" do
    visit class_groups_url
    click_on "New Class Group"

    check "Active" if @class_group.active
    fill_in "Class code", with: @class_group.class_code
    fill_in "Discipline", with: @class_group.discipline
    fill_in "Expiration date", with: @class_group.expiration_date
    fill_in "Responsible", with: @class_group.responsible
    click_on "Create Class group"

    assert_text "Class group was successfully created"
    click_on "Back"
  end

  test "updating a Class group" do
    visit class_groups_url
    click_on "Edit", match: :first

    check "Active" if @class_group.active
    fill_in "Class code", with: @class_group.class_code
    fill_in "Discipline", with: @class_group.discipline
    fill_in "Expiration date", with: @class_group.expiration_date
    fill_in "Responsible", with: @class_group.responsible
    click_on "Update Class group"

    assert_text "Class group was successfully updated"
    click_on "Back"
  end

  test "destroying a Class group" do
    visit class_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Class group was successfully destroyed"
  end
end
