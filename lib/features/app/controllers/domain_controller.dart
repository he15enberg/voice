import 'package:get/get.dart';
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/models/domain_model.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/utils/constants/image_strings.dart';

final List<DomainModel> domainList = [
  DomainModel(
    id: '1',
    name: 'Health & Sanitation Services',
    image: TImages.shoeIcon,
    isFeatured: false,
  ),
  DomainModel(
    id: '2',
    name: 'Food Services & Canteens',
    image: TImages.cosmeticsIcon,
    isFeatured: false,
  ),
  DomainModel(
    id: '3',
    name: 'Sports & Recreation Facilities',
    image: TImages.sportIcon,
    isFeatured: true,
  ),
  DomainModel(
    id: '4',
    name: 'Animals & Pets Care',
    image: TImages.animalIcon,
    isFeatured: false,
  ),
  DomainModel(
    id: '5',
    name: 'Hostel & Accommodation Services',
    image: TImages.furnitureIcon,
    isFeatured: true,
  ),
  DomainModel(
    id: '6',
    name: 'Security & Safety Management',
    image: TImages.jeweleryIcon,
    isFeatured: false,
  ),
  DomainModel(
    id: '7',
    name: 'Transport & Campus Infrastructure',
    image: TImages.toyIcon,
    isFeatured: false,
  ),
  DomainModel(
    id: '8',
    name: "Gym, Park & Recreational Areas",
    image: TImages.clothIcon,
    isFeatured: true,
  ),
  DomainModel(
    id: '9',
    name: 'Infrastructure Maintenance & Repairs',
    image: TImages.electronicsIcon,
    isFeatured: true,
  ),
];

class DomainController extends GetxController {
  static DomainController get instance => Get.find();

  //Variables
  // final _categoryRepositroy = Get.put(CategoryRepository());
  RxList<DomainModel> domains = <DomainModel>[].obs;
  final RxList<PostModel> domainPosts = <PostModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDomains();
  }

  // Load Category Data
  Future<void> fetchAllDomains() async {
    try {
      //Loading
      isLoading.value = true;
      domains.assignAll(domainList);
    } catch (e) {
      //Show error message
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      //Remove Loader
      isLoading.value = false;
    }
  }

  Future<void> loadPostsForDomain(String domainName) async {
    try {
      isLoading.value = true;

      final allPosts = PostController.instance.posts;
      final filteredPosts =
          allPosts.where((post) => post.domain == domainName).toList();

      // Update the reactive list
      domainPosts.assignAll(filteredPosts);
    } catch (e) {
      print("Error fetching posts by domain: $e");
      domainPosts.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
