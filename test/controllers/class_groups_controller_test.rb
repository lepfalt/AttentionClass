require 'test_helper'

class ClassGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @class_group = class_groups(:one)
  end

  test 'should get index' do
    get class_groups_url
    assert_response :success
  end

  test 'should get new' do
    get new_class_group_url
    assert_response :success
  end

  test 'should create class_group' do
    assert_difference('ClassGroup.count') do
      post class_groups_url, params: { class_group: { active: @class_group.active, class_code: @class_group.class_code, discipline: @class_group.discipline, expiration_date: @class_group.expiration_date, responsible: @class_group.responsible } }
    end

    assert_redirected_to class_group_url(ClassGroup.last)
  end

  test 'should show class_group' do
    get class_group_url(@class_group)
    assert_response :success
  end

  test 'should get edit' do
    get edit_class_group_url(@class_group)
    assert_response :success
  end

  test 'should update class_group' do
    patch class_group_url(@class_group), params: { class_group: { active: @class_group.active, class_code: @class_group.class_code, discipline: @class_group.discipline, expiration_date: @class_group.expiration_date, responsible: @class_group.responsible } }
    assert_redirected_to class_group_url(@class_group)
  end

  test 'should destroy class_group' do
    assert_difference('ClassGroup.count', -1) do
      delete class_group_url(@class_group)
    end

    assert_redirected_to class_groups_url
  end
end
