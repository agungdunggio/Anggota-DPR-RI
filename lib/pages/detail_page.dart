import 'package:flutter/material.dart';
import 'package:individual_asessment/data/models/detail_member.dart';
import 'package:individual_asessment/data/service/service_json.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final String memberId;

  const DetailPage({Key? key, required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: Text(
              memberData.nama,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF493628), // Warna AppBar
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
          if (memberData.banner != null && memberData.banner.isNotEmpty)
            Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                'https://dpr.go.id${memberData.banner}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'asset/image/default.png',
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
                color: Color(0xFF493628), // Warna teks judul
              ),
            ),
          ),

          // Tempat dan Tanggal Lahir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.place, color: Color(0xFF493628)), // Ikon
                const SizedBox(width: 8),
                Text(
                  '${memberData.tempatLahir}, ${memberData.tanggalLahir}',
                  style: const TextStyle(color: Color(0xFF493628)),
                ),
              ],
            ),
          ),

          // Agama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.account_balance,
                    color: Color(0xFF493628)), // Ikon
                const SizedBox(width: 8),
                Text(
                  'Agama: ${memberData.agama}',
                  style: const TextStyle(color: Color(0xFF493628)),
                ),
              ],
            ),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pendidikan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF493628), // Warna judul section
              ),
            ),
          ),
          _buildEducationSection(memberData.education),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pekerjaan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF493628),
              ),
            ),
          ),
          _buildJobSection(memberData.job),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Organisasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF493628),
              ),
            ),
          ),
          _buildOrganizationSection(memberData.organization),

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
        child: Text('Tidak ada data pendidikan',
            style: TextStyle(color: Color(0xFF493628))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: education.items.length,
      itemBuilder: (context, index) {
        final edu = education.items[index];
        return ListTile(
          title: Text(edu.sekolah,
              style: const TextStyle(color: Color(0xFF493628))),
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
        child: Text('Tidak ada data pekerjaan',
            style: TextStyle(color: Color(0xFF493628))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: job.items.length,
      itemBuilder: (context, index) {
        final jobItem = job.items[index];
        return ListTile(
          title: Text(jobItem.namaPerusahaan,
              style: const TextStyle(color: Color(0xFF493628))),
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
        child: Text('Tidak ada data organisasi',
            style: TextStyle(color: Color(0xFF493628))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: organization.items.length,
      itemBuilder: (context, index) {
        final orgItem = organization.items[index];
        return ListTile(
          title: Text(orgItem.namaOrganisasi,
              style: const TextStyle(color: Color(0xFF493628))),
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
          Icon(icon, color: const Color(0xFF493628)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              platformName,
              style: const TextStyle(
                color: Color(0xFF493628),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
