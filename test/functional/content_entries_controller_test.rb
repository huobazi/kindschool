require 'test_helper'

class ContentEntriesControllerTest < ActionController::TestCase
  setup do
    @content_entry = content_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:content_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content_entry" do
    assert_difference('ContentEntry.count') do
      post :create, content_entry: { content: @content_entry.content, number: @content_entry.number, page_content_id: @content_entry.page_content_id, resource_id: @content_entry.resource_id, resource_type: @content_entry.resource_type, title: @content_entry.title }
    end

    assert_redirected_to content_entry_path(assigns(:content_entry))
  end

  test "should show content_entry" do
    get :show, id: @content_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @content_entry
    assert_response :success
  end

  test "should update content_entry" do
    put :update, id: @content_entry, content_entry: { content: @content_entry.content, number: @content_entry.number, page_content_id: @content_entry.page_content_id, resource_id: @content_entry.resource_id, resource_type: @content_entry.resource_type, title: @content_entry.title }
    assert_redirected_to content_entry_path(assigns(:content_entry))
  end

  test "should destroy content_entry" do
    assert_difference('ContentEntry.count', -1) do
      delete :destroy, id: @content_entry
    end

    assert_redirected_to content_entries_path
  end
end
