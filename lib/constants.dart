import 'dart:core';
import 'package:flutter/material.dart';

Color kPrimaryColor = Colors.blue.shade900;
const Color kPrimaryLightColor = Color(0xFFF1E6FF);
const String appID = '1043';
const RoundedRectangleBorder sliverAppBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)));
const String app_hash = '72475c87f984f0435e9e5000ded88ff';
const String version_code = '85';
const String is_secure = '0';
const String razorPay_testKey = 'rzp_test_X2PgDf0pdphUNu';

const String clientAPI_URL =
    'https://mobile1.mycareerlift.com/index.php/Get_app_config_v0';
const String studentDetailsAPI_URL =
    'https://mobile1.mycareerlift.com/index.php/app_mob_login_v0';
const String studentPermissionAPI_URL =
    'http://json.mycareerlift.com/api/index.php/App_student_config_v0';
const String userRegPIN_URL =
    'https://mobile1.mycareerlift.com/index.php/app_verify_reg_pin_v0';
const String userRegister_URL =
    'https://mobile1.mycareerlift.com/index.php/app_register_user_v0';
const String studyZoneContent_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_sz_data_v1';
const String currentAffairsContent_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_current_affairs_v0';
const String discussGroupsList_URL =
    'http://mobile1.mycareerlift.com/index.php/app_fetch_group_list_v0';
const String discussPostList_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_post_list_v1';
const String discussPostCommentList_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_edu_comments_v0';
const String discussPostAddComment_URL =
    'https://mobile1.mycareerlift.com/index.php/app_edu_add_post_comment_v0';
const String discussionPostUpvote_URL =
    'https://mobile1.mycareerlift.com/index.php/app_edu_post_upvote_v0';
const String communityAboutPage_URL =
    'http://mobile1.mycareerlift.com/index.php/app_edu_community_about_v0';

const String knowledgeZonePreReading_URL =
    'https://mobile1.mycareerlift.com/index.php/app_all_list_data_v0';

const String getDataByHash_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_data_hash_v0';
const String testList_URL =
    'http://35.244.50.14/index.php/app_fetch_test_list_v0';
const String appCheckVersion_URL =
    'https://mobile1.mycareerlift.com/index.php/App_check_version_v0';
const String appFetchReading_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_reading_v1';
const String getTestQuestions_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_test_questions_v0';
const String postTestResultDetails_URL =
    'https://mobile1.mycareerlift.com/index.php/app_result_submit_v0';
const String fetchResult_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_result_v0';
const String getFLTExamList_URL =
    'https://mobile1.mycareerlift.com/index.php/get_flt_exam';
const String getFLTTestData_URL =
    'https://mobile1.mycareerlift.com/index.php/get_flt_list_v1';
const String getFLTSectionList_URL =
    'https://mobile1.mycareerlift.com/index.php/get_flt_section_list';
const String getSectionQuesList_URL =
    'https://mobile1.mycareerlift.com/index.php/get_flt_question_list';
const String submitFLTTest_URL =
    'https://mobile1.mycareerlift.com/index.php/submit_flt_result';
const String fetchFLTResult_URL =
    'https://mobile1.mycareerlift.com/index.php/fetch_flt_result';
const String fetchPastLiveClasses_URL =
    'https://mobile1.mycareerlift.com/index.php/App_get_liveclass_detail/past_classes';
const String fetchUpcomingLiveClasses_URL =
    'https://mobile1.mycareerlift.com/index.php/App_get_liveclass_detail_v1';
const String fetchAboutUsContent_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_inst_details_v0';
const String fetchInstPostType_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_inst_post_v0';
const String addNewPost_URL =
    'https://mobile1.mycareerlift.com/index.php/app_edu_add_post_v0';
const String getPaymentHistory_URL =
    'http://mobile1.mycareerlift.com/index.php/app_get_payment_history';
const String appCheckEmail_URL =
    'http://mobile1.mycareerlift.com/index.php/app_check_email_v0';
const String getBatchDetail_URL =
    'https://mobile1.mycareerlift.com/index.php/app_fetch_batch_name_v0';
const String submitPayment_URL =
    'http://mobile1.mycareerlift.com/index.php/app_success_payment_info';
const String getPaymentDetail_URL =
    'http://mobile1.mycareerlift.com/index.php/app_get_payment_detail';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 100,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11), topRight: Radius.circular(11))),
      action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
      content: Text(text)));
}

const String StudyZoneString =
    '{home_element_id: 373, status: 1, title_1: Study Zone, title_2: Magazine, Video, seq_no: 12}';
const String StudyZoneString1 =
    '{home_element_id: 373, status: 1, title_1: Study Zone, title_2: Magazine,Video, seq_no: 12}';
const String DiscussScreenString =
    '{home_element_id: 230, status: 1, title_1: Educational Discussion, title_2: Discuss and Learn, seq_no: 5}';

class ExploreConstants {
  ExploreConstants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

const String tncContent = '''Terms and Conditions
Welcome to Speed Labs!

These terms and conditions outline the rules and regulations for the use of Careerlift's Website, located at http://mycareerlift.com.

By accessing this website we assume you accept these terms and conditions. Do not continue to use mycareerlift.com if you do not agree to take all of the terms and conditions stated on this page.

The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: Client, You and Your refers to you, the person log on this website and compliant to the Company’s terms and conditions. The Company, Ourselves, We, Our and Us, refers to our Company. Party, Parties, or Us, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.

Cookies
We employ the use of cookies. By accessing mycareerlift.com, you agreed to use cookies in agreement with the Careerlift's Privacy Policy.

Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.

License
Unless otherwise stated, Careerlift and/or its licensors own the intellectual property rights for all material on mycareerlift.com. All intellectual property rights are reserved. You may access this from mycareerlift.com for your own personal use subjected to restrictions set in these terms and conditions.

You must not:

Republish material from mycareerlift.com
Sell, rent or sub-license material from mycareerlift.com
Reproduce, duplicate or copy material from mycareerlift.com
Redistribute content from mycareerlift.com
This Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator and the Privacy Policy Generator.

Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Careerlift does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Careerlift,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Careerlift shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.

Careerlift reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.

You warrant and represent that:

You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;
The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;
The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy
The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.
You hereby grant Careerlift a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.

Hyperlinking to our Content
The following organizations may link to our Website without prior written approval:

Government agencies;
Search engines;
News organizations;
Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and
System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.
These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.

We may consider and approve other link requests from the following types of organizations:

commonly-known consumer and/or business information sources;
dot.com community sites;
associations or other groups representing charities;
online directory distributors;
internet portals;
accounting, law and consulting firms; and
educational institutions and trade associations.
We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Careerlift; and (d) the link is in the context of general resource information.

These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site.

If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Careerlift. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.

Approved organizations may hyperlink to our Website as follows:

By use of our corporate name; or
By use of the uniform resource locator being linked to; or
By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.
No use of Careerlift's logo or other artwork will be allowed for linking absent a trademark license agreement.

iFrames
Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.

Content Liability
We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.

Your Privacy
Please read Privacy Policy

Reservation of Rights
We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.

Removal of links from our website
If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.

We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.

Disclaimer
To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:

limit or exclude our or your liability for death or personal injury;
limit or exclude our or your liability for fraud or fraudulent misrepresentation;
limit any of our or your liabilities in any way that is not permitted under applicable law; or
exclude any of our or your liabilities that may not be excluded under applicable law.
The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.

As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.''';
