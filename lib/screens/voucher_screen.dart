import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewaqx/services/backend_service.dart';
import 'package:flutter/services.dart'; // For Clipboard
 
 
 
class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});
 
  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}
 
class _VoucherScreenState extends State<VoucherScreen> {
  List<Map<String, dynamic>> vouchers = [];
  bool isLoading = true;
  String errorMessage = '';
  // Get available vouchers (is_available = true)
  List<Map<String, dynamic>> get availableVouchers =>
      vouchers.where((v) => v['is_available'] == true).toList();
 
  // Get unavailable vouchers (is_available = false)
  List<Map<String, dynamic>> get unavailableVouchers =>
      vouchers.where((v) => v['is_available'] != true).toList();
 
  @override
  void initState() {
    super.initState();
    _fetchVouchers();
  }
 
  Future<void> _fetchVouchers() async {
    try {
      final fetchedVouchers = await BackendService.fetchVouchers();
      setState(() {
        vouchers = fetchedVouchers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load vouchers: $e';
        isLoading = false;
      });
    }
  }
 
   Future<void> _redeemVoucher(int voucherId) async {
  // First show confirmation dialog
  bool confirm = await showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confirm Redemption",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF7A1DFF),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Are you sure you want to redeem this voucher?",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF7A1DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
 
  if (confirm != true) return;
 
  try {
 
    final result = await BackendService.redeemVoucher(voucherId);
    print('Processed Result: $result'); // Debug print
 
    if (result['success'] == true) {
      // Safe access with null checks
      final voucherData = result['data'] ?? {};
      final voucher = voucherData['voucher'] ?? {};
      final voucherCode = voucher['code']?.toString() ?? 'CODE_NOT_FOUND';
 
      // Show success dialog with voucher code
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                "Voucher Redeemed!",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF7A1DFF),
                ),
              ),
              SizedBox(height: 16),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(height: 16),
                Text(
                  "Voucher redeemed successfully!",
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          voucherCode,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Color(0xFF7A1DFF)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: voucherCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Voucher code copied!",
                                style: TextStyle(fontFamily: 'Quicksand'),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xFF7A1DFF),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Tap the copy icon to save your voucher code",
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF7A1DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
 
      // Refresh the list
      await _fetchVouchers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Failed to redeem voucher',
            style: TextStyle(fontFamily: 'Quicksand'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to redeem voucher: $e',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    print('Vouchers data: $vouchers');
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Rewards Store',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF7A1DFF),
            ),
          ),
          centerTitle: true,
          shadowColor: const Color(0x1A1B1D36),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A1B1D36),
                  offset: Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            // Promo banner
                            Container(
                              width: 370,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(122, 29, 255, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: SvgPicture.asset(
                                      'assets/images/traingleEffect.svg',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Turn Your Points into Rewards! 🎟️',
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Your hard work deserves a treat! 🎉 \nRedeem your points for exclusive vouchers and enjoy amazing deals on your favorite brands, services, and more.',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 27),
                            Text(
                              'Get rewarded',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Quicksand",
                              ),
                            ),
                            SizedBox(height: 16),
                            if (availableVouchers.isNotEmpty) ...[
                           
                            ...availableVouchers.map((voucher) => VoucherCard(
                                  voucherId: voucher['voucherid'],
                                  title: voucher['title'],
                                  points: '${voucher['point_cost']} Points',
                                  value: '${voucher['value']}',
                                  imagePath: voucher['logo'] ?? 'assets/images/ga.png',
                                  svgPath: 'assets/images/voucher.svg',
                                  onRedeem: () => _redeemVoucher(voucher['voucherid']),
                                  isAvailable: true,
                                )).toList(),
                            SizedBox(height: 24),
                          ],
                         
                          // Unavailable Vouchers Section
                          if (unavailableVouchers.isNotEmpty) ...[
                           
                            ...unavailableVouchers.map((voucher) => VoucherCard(
                                  voucherId: voucher['voucherid'],
                                  title: voucher['title'],
                                  points: '${voucher['point_cost']} Points',
                                  value: '${voucher['value']}',
                                  imagePath: voucher['logo'] ?? 'assets/images/ga.png',
                                  svgPath: 'assets/images/voucher.svg',
                                  onRedeem: () {}, // Empty callback for unavailable
                                  isAvailable: false,
                                )).toList(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
  );
                   
  }
}
 
 
class VoucherCard extends StatelessWidget {
  final int voucherId;
  final String title;
  final String points;
  final String value;
  final String? imagePath; // Make nullable
  final String svgPath;
  final VoidCallback onRedeem;
  final bool isAvailable; // Add this parameter
 
 
  const VoucherCard({
    super.key,
    required this.voucherId,
    required this.title,
    required this.points,
    required this.value,
    this.imagePath,
    required this.svgPath,
    required this.onRedeem,
    this.isAvailable = true, // Default to true
  });
 
 
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 103,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // White rectangle (coupon part)
          Container(
            width: 300,
            height: 103,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon for the voucher card - with better error handling
                  _buildVoucherImage(),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                          ),
                        ),
                        Text(
                          '$value = $points',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Quicksand",
                          ),
                        ),
                        SizedBox(height: 8),
                        // Redeem Voucher Button
                        // Replace the GestureDetector and Container with this:
                        // Replace the button section in your VoucherCard with this:
                      Container(
                        width: 130,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: isAvailable
                                ? Colors.black.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.3),
                          ),
                          color: isAvailable
                              ? Color.fromRGBO(42, 210, 201, 1)
                              : Colors.grey[300],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: isAvailable ? onRedeem : null, // Only allow taps when available
                            child: Center(
                              child: Text(
                                isAvailable ? 'Redeem Voucher' : 'Unavailable',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand",
                                  color: isAvailable
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SVG connected to the right
          SvgPicture.asset(
            svgPath,
            width: 45,
            height: 103,
          ),
        ],
      ),
    );
  }
 
 
  Widget _buildVoucherImage() {
  // If no image path provided, use default icon
  if (imagePath == null || imagePath!.isEmpty) {
    return Icon(Icons.card_giftcard, size: 34);
  }
 
  // Handle network images - prepend your base URL if it's a local path
  String imageUrl;
  if (imagePath!.startsWith('http')) {
    imageUrl = imagePath!;
  } else if (imagePath!.startsWith('assets/')) {
    // For local assets
    return Image.asset(
      imagePath!,
      width: 34,
      height: 34,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.card_giftcard, size: 34),
    );
  } else {
    // For server images - prepend your base URL
    imageUrl = 'http://rewaqx.test/images/$imagePath';
  }
 
  return Image.network(
    imageUrl,
    width: 34,
    height: 34,
    errorBuilder: (context, error, stackTrace) =>
        Icon(Icons.card_giftcard, size: 34),
  );
}
}