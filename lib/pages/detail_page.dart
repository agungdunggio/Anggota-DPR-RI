import 'package:flutter/material.dart';
import 'package:individual_asessment/data/models/detail_member.dart';
import 'package:individual_asessment/data/service/service_json.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure the import matches your project structure

class DetailPage extends StatelessWidget {
  final String memberId;

  const DetailPage({Key? key, required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch member detail using memberId
    final memberDataFuture = ServiceJson().fetchMemberDetail();
    return FutureBuilder<MemberDetail>(
      future: memberDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Tidak ada data'));
        }

        final memberData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(memberData.nama),
          ),
          body: _buildDetailContent(memberData),
        );
      },
    );
  }

  Widget _buildDetailContent(MemberDetail memberData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          if (memberData.banner != null && memberData.banner.isNotEmpty)
            Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                'https://dpr.go.id${memberData.banner}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Jika terjadi kesalahan, tampilkan gambar default
                  return Image.asset(
                    'asset/image/default.png', // Gambar default lokal
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

          // Nama
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              memberData.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tempat dan Tanggal Lahir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.place),
                const SizedBox(width: 8),
                Text(
                    '${memberData.tempatLahir}, ${memberData.tanggalLahir}'), // Fixed the field
              ],
            ),
          ),

          // Agama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.account_balance),
                const SizedBox(width: 8),
                Text('Agama: ${memberData.agama}'),
              ],
            ),
          ),

          const Divider(),

          // Pendidikan Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pendidikan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildEducationSection(memberData.education),

          const Divider(),

          // Pekerjaan Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pekerjaan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildJobSection(memberData.job),

          const Divider(),

          // Organisasi Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Organisasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildOrganizationSection(memberData.organization),

          // Link to Social Media
          _buildSocialMediaLinks(memberData),
        ],
      ),
    );
  }

  // Pendidikan Section
  Widget _buildEducationSection(Education? education) {
    if (education == null || education.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Tidak ada data pendidikan'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: education.items.length,
      itemBuilder: (context, index) {
        final edu = education.items[index];
        return ListTile(
          title: Text(edu.sekolah),
          subtitle: Text(
            '${edu.tahunMasuk} - ${edu.tahunLulus} (${edu.jurusan ?? 'Tidak ada jurusan'})',
          ),
        );
      },
    );
  }

  // Pekerjaan Section
  Widget _buildJobSection(Job? job) {
    if (job == null || job.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Tidak ada data pekerjaan'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: job.items.length,
      itemBuilder: (context, index) {
        final jobItem = job.items[index];
        return ListTile(
          title: Text(jobItem.namaPerusahaan),
          subtitle: Text(
            '${jobItem.tahunAwal ?? '-'} - ${jobItem.tahunAkhir ?? 'Sekarang'} (${jobItem.jabatan})',
          ),
        );
      },
    );
  }

  // Organisasi Section
  Widget _buildOrganizationSection(Organization? organization) {
    if (organization == null || organization.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Tidak ada data organisasi'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: organization.items.length,
      itemBuilder: (context, index) {
        final orgItem = organization.items[index];
        return ListTile(
          title: Text(orgItem.namaOrganisasi),
          subtitle: Text(
            '${orgItem.tahunAwal ?? '-'} - ${orgItem.tahunAkhir ?? 'Sekarang'} (${orgItem.jabatan})',
          ),
        );
      },
    );
  }

  // Social Media Links Section
  Widget _buildSocialMediaLinks(MemberDetail memberData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (memberData.urlFacebook != null &&
              memberData.urlFacebook!.isNotEmpty)
            _buildSocialMediaIcon(
                Icons.facebook, memberData.urlFacebook!, 'Facebook'),
          if (memberData.urlYoutube != null &&
              memberData.urlYoutube!.isNotEmpty)
            _buildSocialMediaIcon(
                Icons.youtube_searched_for, memberData.urlYoutube!, 'YouTube'),
          if (memberData.urlWebsite != null &&
              memberData.urlWebsite!.isNotEmpty)
            _buildSocialMediaIcon(Icons.web, memberData.urlWebsite!, 'Website'),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(IconData icon, String url, String platformName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(platformName,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:individual_asessment/data/models/detail_member.dart';
// import 'package:individual_asessment/data/models/members.dart';
// import 'package:individual_asessment/data/service/service_json.dart'; // Sesuaikan import sesuai struktur proyek Anda

// class DetailPage extends StatelessWidget {
//   final String memberId;


//   const DetailPage({Key? key, required this.memberId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//   final memberData = ServiceJson().fetchMemberDetail(); 
//     return FutureBuilder<MemberDetail>(
//       future: memberData, // Memanggil fungsi fetchMemberDetail
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('Tidak ada data'));
//         }

//         final memberData = snapshot.data!;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(memberData.nama ?? 'Detail Anggota'),
//           ),
//           body: _buildDetailContent(memberData),
//         );
//       },
//     );
//   }

//   Widget _buildDetailContent(MemberDetail memberData) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Banner Image
//           if (memberData.banner != null && memberData.banner.isNotEmpty)
//             Container(
//               width: double.infinity,
//               height: 200,
//               child: Image.network(
//                 'https://dpr.go.id${memberData.banner}',
//                 fit: BoxFit.cover,
//               ),
//             ),

//           // Nama
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               memberData.nama ?? 'Tidak ada nama',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           // Tempat dan Tanggal Lahir
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.place),
//                 const SizedBox(width: 8),
//                 Text('${memberData.tempatLahir}, ${memberData.tempatLahir}'),
//               ],
//             ),
//           ),

//           // Agama
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.account_balance),
//                 const SizedBox(width: 8),
//                 Text('Agama: ${memberData.agama}'),
//               ],
//             ),
//           ),

//           const Divider(),

//           // Pendidikan Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Pendidikan',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildEducationSection(memberData.education),

//           const Divider(),

//           // Pekerjaan Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Pekerjaan',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildJobSection(memberData.job),

//           const Divider(),

//           // Organisasi Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Organisasi',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildOrganizationSection(memberData.organization),

//           // Link to Social Media
//           _buildSocialMediaLinks(memberData),
//         ],
//       ),
//     );
//   }

//   // Pendidikan Section
//   Widget _buildEducationSection(Education? education) {
//     if (education == null || education.items == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pendidikan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: education.items.length,
//       itemBuilder: (context, index) {
//         final edu = education.items[index];
//         return ListTile(
//           title: Text(edu.sekolah ?? 'Tidak ada sekolah'),
//           subtitle: Text(
//             '${edu.tahunMasuk} - ${edu.tahunLulus} (${edu.jurusan ?? 'Tidak ada jurusan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Pekerjaan Section
//   Widget _buildJobSection(Job? job) {
//     if (job == null || job.items == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pekerjaan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: job.items.length,
//       itemBuilder: (context, index) {
//         final jobItem = job.items[index];
//         return ListTile(
//           title: Text(jobItem.namaPerusahaan ?? 'Tidak ada perusahaan'),
//           subtitle: Text(
//             '${jobItem.tahunAwal ?? '-'} - ${jobItem.tahunAkhir ?? 'Sekarang'} (${jobItem.jabatan ?? 'Tidak ada jabatan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Organisasi Section
//   Widget _buildOrganizationSection(Organization? organization) {
//     if (organization == null || organization.items == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data organisasi'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: organization.items.length,
//       itemBuilder: (context, index) {
//         final orgItem = organization.items[index];
//         return ListTile(
//           title: Text(orgItem.namaOrganisasi ?? 'Tidak ada organisasi'),
//           subtitle: Text(
//             '${orgItem.tahunAwal ?? '-'} - ${orgItem.tahunAkhir ?? 'Sekarang'} (${orgItem.jabatan ?? 'Tidak ada jabatan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Social Media Links Section
//   Widget _buildSocialMediaLinks(Map<String, dynamic> memberData) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (memberData['url_facebook'] != null && memberData['url_facebook'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.facebook, memberData['url_facebook']),
//           if (memberData['url_youtube'] != null && memberData['url_youtube'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.youtube_searched_for, memberData['url_youtube']),
//           if (memberData['url_website'] != null && memberData['url_website'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.web, memberData['url_website']),
//         ],
//       ),
//     );
//   }

//   // Widget untuk Social Media Icon
//   Widget _buildSocialMediaIcon(IconData icon, String url) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               // Arahkan ke URL
//               // Anda dapat menggunakan package url_launcher untuk membuka URL
//             },
//             child: Text(url, style: const TextStyle(color: Colors.blue)),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:individual_asessment/data/models/members.dart';
// import 'package:individual_asessment/data/service/service_json.dart'; // Adjust import according to your project structure

// class DetailPage extends StatelessWidget {
//   final String memberId;

//   const DetailPage({Key? key, required this.memberId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Fetch member details using the member ID
//     final memberData = ServiceJson().fetchMemberDetail(); // Modify this line as per your data fetching logic

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(memberData != null ? memberData. : 'Detail Anggota'),
//       ),
//       body: memberData != null ? _buildDetailContent(memberData) : const Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildDetailContent(Map<String, dynamic> memberData) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Banner Image
//           if (memberData['banner'] != null && memberData['banner'].isNotEmpty)
//             Container(
//               width: double.infinity,
//               height: 200,
//               child: Image.network(
//                 'https://dpr.go.id${memberData['banner']}',
//                 fit: BoxFit.cover,
//               ),
//             ),

//           // Nama
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               memberData['nama'] ?? 'Tidak ada nama',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           // Tempat dan Tanggal Lahir
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.place),
//                 const SizedBox(width: 8),
//                 Text('${memberData['tempat_lahir']}, ${memberData['tanggal_lahir']}'),
//               ],
//             ),
//           ),

//           // Agama
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.account_balance),
//                 const SizedBox(width: 8),
//                 Text('Agama: ${memberData['agama']}'),
//               ],
//             ),
//           ),

//           const Divider(),

//           // Pendidikan Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Pendidikan',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildEducationSection(memberData['pendidikan']),

//           const Divider(),

//           // Pekerjaan Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Pekerjaan',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildJobSection(memberData['pekerjaan']),

//           const Divider(),

//           // Organisasi Section
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Organisasi',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildOrganizationSection(memberData['organisasi']),

//           // Link to Social Media
//           _buildSocialMediaLinks(memberData),
//         ],
//       ),
//     );
//   }

//   // Pendidikan Section
//   Widget _buildEducationSection(Map<String, dynamic>? education) {
//     if (education == null || education['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pendidikan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: education['item'].length,
//       itemBuilder: (context, index) {
//         final edu = education['item'][index];
//         return ListTile(
//           title: Text(edu['sekolah'] ?? 'Tidak ada sekolah'),
//           subtitle: Text(
//             '${edu['tahun_masuk']} - ${edu['tahun_lulus']} (${edu['jurusan'] ?? 'Tidak ada jurusan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Pekerjaan Section
//   Widget _buildJobSection(Map<String, dynamic>? job) {
//     if (job == null || job['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pekerjaan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: job['item'].length,
//       itemBuilder: (context, index) {
//         final jobItem = job['item'][index];
//         return ListTile(
//           title: Text(jobItem['nama_perusahaan'] ?? 'Tidak ada perusahaan'),
//           subtitle: Text(
//             '${jobItem['tahun_awal'] ?? '-'} - ${jobItem['tahun_akhir'] ?? 'Sekarang'} (${jobItem['jabatan'] ?? 'Tidak ada jabatan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Organisasi Section
//   Widget _buildOrganizationSection(Map<String, dynamic>? organization) {
//     if (organization == null || organization['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data organisasi'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: organization['item'].length,
//       itemBuilder: (context, index) {
//         final orgItem = organization['item'][index];
//         return ListTile(
//           title: Text(orgItem['nama_organisasi'] ?? 'Tidak ada organisasi'),
//           subtitle: Text(
//             '${orgItem['tahun_awal'] ?? '-'} - ${orgItem['tahun_akhir'] ?? 'Sekarang'} (${orgItem['jabatan'] ?? 'Tidak ada jabatan'})',
//           ),
//         );
//       },
//     );
//   }

//   // Social Media Links Section
//   Widget _buildSocialMediaLinks(Map<String, dynamic> memberData) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (memberData['url_facebook'] != null && memberData['url_facebook'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.facebook, memberData['url_facebook']),
//           if (memberData['url_youtube'] != null && memberData['url_youtube'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.youtube_searched_for, memberData['url_youtube']),
//           if (memberData['url_website'] != null && memberData['url_website'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.web, memberData['url_website']),
//         ],
//       ),
//     );
//   }

//   // Widget untuk Social Media Icon
//   Widget _buildSocialMediaIcon(IconData icon, String url) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               // Arahkan ke URL
//               // You can use url_launcher package to open URLs
//             },
//             child: Text(url, style: const TextStyle(color: Colors.blue)),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';

// class DetailPage extends StatelessWidget {
//   final String memberId;


//   const DetailPage({Key? key, required this.memberId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(memberData['nama'] ?? 'Detail Anggota'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Banner Image
//             if (memberData['banner'] != null && memberData['banner'].isNotEmpty)
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 child: Image.network(
//                   'https://dpr.go.id${memberData['banner']}',
//                   fit: BoxFit.cover,
//                 ),
//               ),

//             // Nama
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 memberData['nama'] ?? 'Tidak ada nama',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             // Tempat dan Tanggal Lahir
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   const Icon(Icons.place),
//                   const SizedBox(width: 8),
//                   Text('${memberData['tempat_lahir']}, ${memberData['tanggal_lahir']}'),
//                 ],
//               ),
//             ),

//             // Agama
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   const Icon(Icons.account_balance),
//                   const SizedBox(width: 8),
//                   Text('Agama: ${memberData['agama']}'),
//                 ],
//               ),
//             ),

//             const Divider(),

//             // Pendidikan Section
//             const Padding(
//               padding:  EdgeInsets.all(16.0),
//               child: Text(
//                 'Pendidikan',
//                 style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             _buildEducationSection(memberData['pendidikan']),

//             const Divider(),

//             // Pekerjaan Section
//             const Padding(
//               padding:  EdgeInsets.all(16.0),
//               child: Text(
//                 'Pekerjaan',
//                 style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             _buildJobSection(memberData['pekerjaan']),

//             const Divider(),

//             // Organisasi Section
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Organisasi',
//                 style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             _buildOrganizationSection(memberData['organisasi']),

//             // Link to Social Media
//             _buildSocialMediaLinks(memberData),
//           ],
//         ),
//       ),
//     );
//   }

//   // Pendidikan Section
//   Widget _buildEducationSection(Map<String, dynamic>? education) {
//     if (education == null || education['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pendidikan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: education['item'].length,
//       itemBuilder: (context, index) {
//         final edu = education['item'][index];
//         return ListTile(
//           title: Text(edu['sekolah'] ?? 'Tidak ada sekolah'),
//           subtitle: Text(
//               '${edu['tahun_masuk']} - ${edu['tahun_lulus']} (${edu['jurusan'] ?? 'Tidak ada jurusan'})'),
//         );
//       },
//     );
//   }

//   // Pekerjaan Section
//   Widget _buildJobSection(Map<String, dynamic>? job) {
//     if (job == null || job['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data pekerjaan'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: job['item'].length,
//       itemBuilder: (context, index) {
//         final jobItem = job['item'][index];
//         return ListTile(
//           title: Text(jobItem['nama_perusahaan'] ?? 'Tidak ada perusahaan'),
//           subtitle: Text(
//               '${jobItem['tahun_awal'] ?? '-'} - ${jobItem['tahun_akhir'] ?? 'Sekarang'} (${jobItem['jabatan'] ?? 'Tidak ada jabatan'})'),
//         );
//       },
//     );
//   }

//   // Organisasi Section
//   Widget _buildOrganizationSection(Map<String, dynamic>? organization) {
//     if (organization == null || organization['item'] == null) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text('Tidak ada data organisasi'),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: organization['item'].length,
//       itemBuilder: (context, index) {
//         final orgItem = organization['item'][index];
//         return ListTile(
//           title: Text(orgItem['nama_organisasi'] ?? 'Tidak ada organisasi'),
//           subtitle: Text(
//               '${orgItem['tahun_awal'] ?? '-'} - ${orgItem['tahun_akhir'] ?? 'Sekarang'} (${orgItem['jabatan'] ?? 'Tidak ada jabatan'})'),
//         );
//       },
//     );
//   }

//   // Social Media Links Section
//   Widget _buildSocialMediaLinks(Map<String, dynamic> memberData) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (memberData['url_facebook'] != null && memberData['url_facebook'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.facebook, memberData['url_facebook']),
//           if (memberData['url_youtube'] != null && memberData['url_youtube'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.youtube_searched_for, memberData['url_youtube']),
//           if (memberData['url_website'] != null && memberData['url_website'].isNotEmpty)
//             _buildSocialMediaIcon(Icons.web, memberData['url_website']),
//         ],
//       ),
//     );
//   }

//   // Widget untuk Social Media Icon
//   Widget _buildSocialMediaIcon(IconData icon, String url) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               // Arahkan ke URL
//             },
//             child: Text(url, style: const TextStyle(color: Colors.blue)),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// class DetailPage extends StatelessWidget {
//   const DetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // logo
//               Padding(
//                 padding: const EdgeInsets.all(25.0),
//                 child: Image.network(
//                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1tsJlbwuBC2jBGT4llDSBftZxNDkGVkI1YQ&s',
//                   height: 240,
//                 ),
//               ),

//               const SizedBox(
//                 height: 48,
//               ),

//               // title
//               Text(
//                 'Rafli Gobel',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),

//               const SizedBox(
//                 height: 24,
//               ),

//               // sub title
//               Text(
//                 'Jagerly lerom lorem ipsLongPressMoveUpdateDetails LongPressMoveUpdateDetails LongPressMoveUpdateDetails',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),

//               // start now button
//               GestureDetector(
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailPage(),
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(12)),
//                   padding: const EdgeInsets.all(25),
//                   child: const Center(
//                     child: Text(
//                       'View Details',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
