require 'test_helper'

class PhysicalRecordsControllerTest < ActionController::TestCase
  setup do
    @physical_record = physical_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:physical_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create physical_record" do
    assert_difference('PhysicalRecord.count') do
      post :create, physical_record: { content: @physical_record.content, creater_id: @physical_record.creater_id, kindergarten_id: @physical_record.kindergarten_id, send_date: @physical_record.send_date, student_info_id: @physical_record.student_info_id }
    end

    assert_redirected_to physical_record_path(assigns(:physical_record))
  end

  test "should show physical_record" do
    get :show, id: @physical_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @physical_record
    assert_response :success
  end

  test "should update physical_record" do
    put :update, id: @physical_record, physical_record: { content: @physical_record.content, creater_id: @physical_record.creater_id, kindergarten_id: @physical_record.kindergarten_id, send_date: @physical_record.send_date, student_info_id: @physical_record.student_info_id }
    assert_redirected_to physical_record_path(assigns(:physical_record))
  end

  test "should destroy physical_record" do
    assert_difference('PhysicalRecord.count', -1) do
      delete :destroy, id: @physical_record
    end

    assert_redirected_to physical_records_path
  end
end
