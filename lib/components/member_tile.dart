import 'package:flutter/material.dart';
import 'package:individual_asessment/data/models/members.dart';
import 'package:individual_asessment/pages/detail_page.dart';

class MemberTile extends StatelessWidget {
  static const _host = 'dpr.go.id';
  final Members member;

  const MemberTile({super.key, required this.member});

  String _getFraksiImage(String fraksi) {
    switch (fraksi) {
      case 'Fraksi Partai Kebangkitan Bangsa':
        return 'asset/image/logo/pkb.png';
      case 'Fraksi Partai Gerakan Indonesia Raya':
        return 'asset/image/logo/gerindra.png';
      case 'Fraksi Partai Demokrasi Indonesia Perjuangan':
        return 'asset/image/logo/pdip.png';
      case 'Fraksi Partai Golongan Karya':
        return 'asset/image/logo/golkar.png';
      case 'Fraksi Partai NasDem':
        return 'asset/image/logo/nasdem.png';
      case 'Fraksi Partai Keadilan Sejahtera':
        return 'asset/image/logo/pks.png';
      case 'Fraksi Partai Persatuan Pembangunan':
        return 'asset/image/logo/ppp.png';
      case 'Fraksi Partai Amanat Nasional':
        return 'asset/image/logo/pan.png';
      case 'Fraksi Partai Demokrat':
        return 'asset/image/logo/demokrat.png';
      default:
        return 'asset/image/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(memberId: member.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF493628),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      'https://$_host${member.foto}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'asset/image/default.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF493628), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _getFraksiImage(member.fraksi),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                member.nama,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: SizedBox(
                height: 49,
                child: ListView.builder(
                  itemCount: member.daftarAkd.akd.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        member.daftarAkd.akd[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                member.dapil,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
