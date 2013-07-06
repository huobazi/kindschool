require 'test_helper'

class StudentInfosControllerTest < ActionController::TestCase
  setup do
    @student_info = student_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_info" do
    assert_difference('StudentInfo.count') do
      post :create, student_info: { birthday: @student_info.birthday, birthplace: @student_info.birthplace, brothers: @student_info.brothers, card_category: @student_info.card_category, card_code: @student_info.card_code, children_number: @student_info.children_number, come_in_at: @student_info.come_in_at, deformity: @student_info.deformity, deformity_category: @student_info.deformity_category, domicile_place: @student_info.domicile_place, duties: @student_info.duties, education: @student_info.education, employofficialt: @student_info.employofficialt, family_address: @student_info.family_address, family_birthday: @student_info.family_birthday, family_email: @student_info.family_email, family_marital: @student_info.family_marital, family_name: @student_info.family_name, family_phone: @student_info.family_phone, family_register: @student_info.family_register, family_ties: @student_info.family_ties, grade_id: @student_info.grade_id, guardian: @student_info.guardian, guardian_card_category: @student_info.guardian_card_category, guardian_card_code: @student_info.guardian_card_code, head_url: @student_info.head_url, household: @student_info.household, housing: @student_info.housing, insured: @student_info.insured, kindergarten_id: @student_info.kindergarten_id, leftover_children: @student_info.leftover_children, live_family: @student_info.live_family, living_time: @student_info.living_time, lodging: @student_info.lodging, nation: @student_info.nation, nationality: @student_info.nationality, native: @student_info.native, only_child: @student_info.only_child, orphan: @student_info.orphan, overseas_chinese: @student_info.overseas_chinese, politics_status: @student_info.politics_status, profession: @student_info.profession, safe_box: @student_info.safe_box, squad_id: @student_info.squad_id, subsidize: @student_info.subsidize, working: @student_info.working }
    end

    assert_redirected_to student_info_path(assigns(:student_info))
  end

  test "should show student_info" do
    get :show, id: @student_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_info
    assert_response :success
  end

  test "should update student_info" do
    put :update, id: @student_info, student_info: { birthday: @student_info.birthday, birthplace: @student_info.birthplace, brothers: @student_info.brothers, card_category: @student_info.card_category, card_code: @student_info.card_code, children_number: @student_info.children_number, come_in_at: @student_info.come_in_at, deformity: @student_info.deformity, deformity_category: @student_info.deformity_category, domicile_place: @student_info.domicile_place, duties: @student_info.duties, education: @student_info.education, employofficialt: @student_info.employofficialt, family_address: @student_info.family_address, family_birthday: @student_info.family_birthday, family_email: @student_info.family_email, family_marital: @student_info.family_marital, family_name: @student_info.family_name, family_phone: @student_info.family_phone, family_register: @student_info.family_register, family_ties: @student_info.family_ties, grade_id: @student_info.grade_id, guardian: @student_info.guardian, guardian_card_category: @student_info.guardian_card_category, guardian_card_code: @student_info.guardian_card_code, head_url: @student_info.head_url, household: @student_info.household, housing: @student_info.housing, insured: @student_info.insured, kindergarten_id: @student_info.kindergarten_id, leftover_children: @student_info.leftover_children, live_family: @student_info.live_family, living_time: @student_info.living_time, lodging: @student_info.lodging, nation: @student_info.nation, nationality: @student_info.nationality, native: @student_info.native, only_child: @student_info.only_child, orphan: @student_info.orphan, overseas_chinese: @student_info.overseas_chinese, politics_status: @student_info.politics_status, profession: @student_info.profession, safe_box: @student_info.safe_box, squad_id: @student_info.squad_id, subsidize: @student_info.subsidize, working: @student_info.working }
    assert_redirected_to student_info_path(assigns(:student_info))
  end

  test "should destroy student_info" do
    assert_difference('StudentInfo.count', -1) do
      delete :destroy, id: @student_info
    end

    assert_redirected_to student_infos_path
  end
end
