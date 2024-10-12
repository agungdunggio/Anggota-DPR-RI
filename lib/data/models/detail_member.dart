class MemberDetail {
  final String banner;
  final String nama;
  final String noAnggota;
  final String tempatLahir;
  final String tanggalLahir;
  final String agama;
  final Education education;
  final Job job;
  final Organization organization;
  final String? urlFacebook;
  final String? urlYoutube;
  final String? urlWebsite;

  MemberDetail({
    required this.banner,
    required this.nama,
    required this.noAnggota,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.agama,
    required this.education,
    required this.job,
    required this.organization,
    this.urlFacebook,
    this.urlYoutube,
    this.urlWebsite,
  });

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    return MemberDetail(
      banner: json['banner'] ?? '',
      nama: json['nama'] ?? '',
      noAnggota: json['no_anggota'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      agama: json['agama'] ?? '',
      education: Education.fromJson(json['pendidikan']),
      job: Job.fromJson(json['pekerjaan']),
      organization: Organization.fromJson(json['organisasi']),
      urlFacebook: json['url_facebook'],
      urlYoutube: json['url_youtube'],
      urlWebsite: json['url_website'],
    );
  }
}

class Education {
  final List<EducationItem> items;

  Education({required this.items});

  factory Education.fromJson(Map<String, dynamic> json) {
    var list = json['item'] as List;
    List<EducationItem> educationItems =
        list.map((i) => EducationItem.fromJson(i)).toList();
    return Education(items: educationItems);
  }
}

class EducationItem {
  final String sekolah;
  final String tahunMasuk;
  final String tahunLulus;
  final String? jurusan;

  EducationItem({
    required this.sekolah,
    required this.tahunMasuk,
    required this.tahunLulus,
    this.jurusan,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      sekolah: json['sekolah'] ?? '',
      tahunMasuk: json['tahun_masuk'] ?? '',
      tahunLulus: json['tahun_lulus'] ?? '',
      jurusan: json['jurusan']?.toString(),
    );
  }
}

class Job {
  final List<JobItem> items;

  Job({required this.items});

  factory Job.fromJson(Map<String, dynamic> json) {
    var list = json['item'] as List;
    List<JobItem> jobItems = list.map((i) => JobItem.fromJson(i)).toList();
    return Job(items: jobItems);
  }
}

class JobItem {
  final String namaPerusahaan;
  final String jabatan;
  final String? tahunAwal;
  final String? tahunAkhir;

  JobItem({
    required this.namaPerusahaan,
    required this.jabatan,
    this.tahunAwal,
    this.tahunAkhir,
  });

  factory JobItem.fromJson(Map<String, dynamic> json) {
    return JobItem(
      namaPerusahaan: json['nama_perusahaan'] ?? '',
      jabatan: json['jabatan'] ?? '',
      tahunAwal: json['tahun_awal']?.toString(),
      tahunAkhir: json['tahun_akhir']?.toString(),
    );
  }
}

class Organization {
  final List<OrganizationItem> items;

  Organization({required this.items});

  factory Organization.fromJson(Map<String, dynamic> json) {
    var list = json['item'] as List;
    List<OrganizationItem> organizationItems =
        list.map((i) => OrganizationItem.fromJson(i)).toList();
    return Organization(items: organizationItems);
  }
}

class OrganizationItem {
  final String namaOrganisasi;
  final String jabatan;
  final String? tahunAwal;
  final String? tahunAkhir;

  OrganizationItem({
    required this.namaOrganisasi,
    required this.jabatan,
    this.tahunAwal,
    this.tahunAkhir,
  });

  factory OrganizationItem.fromJson(Map<String, dynamic> json) {
    return OrganizationItem(
      namaOrganisasi: json['nama_organisasi'] ?? '',
      jabatan: json['jabatan'] ?? '',
      tahunAwal: json['tahun_awal']?.toString(),
      tahunAkhir: json['tahun_akhir']?.toString(),
    );
  }
}
