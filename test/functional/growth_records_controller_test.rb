require 'test_helper'

class GrowthRecordsControllerTest < ActionController::TestCase
  setup do
    @growth_record = growth_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:growth_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create growth_record" do
    assert_difference('GrowthRecord.count') do
      post :create, growth_record: { content: @growth_record.content, creater_id: @growth_record.creater_id, end_at: @growth_record.end_at, kindergarten_id: @growth_record.kindergarten_id, squad_name: @growth_record.squad_name, start_at: @growth_record.start_at, student_info_id: @growth_record.student_info_id, tp: @growth_record.tp }
    end

    assert_redirected_to growth_record_path(assigns(:growth_record))
  end

  test "should show growth_record" do
    get :show, id: @growth_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @growth_record
    assert_response :success
  end

  test "should update growth_record" do
    put :update, id: @growth_record, growth_record: { content: @growth_record.content, creater_id: @growth_record.creater_id, end_at: @growth_record.end_at, kindergarten_id: @growth_record.kindergarten_id, squad_name: @growth_record.squad_name, start_at: @growth_record.start_at, student_info_id: @growth_record.student_info_id, tp: @growth_record.tp }
    assert_redirected_to growth_record_path(assigns(:growth_record))
  end

  test "should destroy growth_record" do
    assert_difference('GrowthRecord.count', -1) do
      delete :destroy, id: @growth_record
    end

    assert_redirected_to growth_records_path
  end
end
