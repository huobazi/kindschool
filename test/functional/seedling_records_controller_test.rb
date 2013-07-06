require 'test_helper'

class SeedlingRecordsControllerTest < ActionController::TestCase
  setup do
    @seedling_record = seedling_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seedling_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seedling_record" do
    assert_difference('SeedlingRecord.count') do
      post :create, seedling_record: { creater_id: @seedling_record.creater_id, expire_at: @seedling_record.expire_at, kindergarten_id: @seedling_record.kindergarten_id, name: @seedling_record.name, note: @seedling_record.note, shot_at: @seedling_record.shot_at, student_info_id: @seedling_record.student_info_id }
    end

    assert_redirected_to seedling_record_path(assigns(:seedling_record))
  end

  test "should show seedling_record" do
    get :show, id: @seedling_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seedling_record
    assert_response :success
  end

  test "should update seedling_record" do
    put :update, id: @seedling_record, seedling_record: { creater_id: @seedling_record.creater_id, expire_at: @seedling_record.expire_at, kindergarten_id: @seedling_record.kindergarten_id, name: @seedling_record.name, note: @seedling_record.note, shot_at: @seedling_record.shot_at, student_info_id: @seedling_record.student_info_id }
    assert_redirected_to seedling_record_path(assigns(:seedling_record))
  end

  test "should destroy seedling_record" do
    assert_difference('SeedlingRecord.count', -1) do
      delete :destroy, id: @seedling_record
    end

    assert_redirected_to seedling_records_path
  end
end
