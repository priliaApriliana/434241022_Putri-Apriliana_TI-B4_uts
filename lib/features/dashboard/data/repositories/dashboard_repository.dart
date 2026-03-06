import '../models/dashboard_model.dart';

class DashboardRepository {
  /// Mendapatkan data dashboard dengan simulasi delay network
  Future<DashboardData> getDashboardData() async {
    //network delay
    await Future.delayed(const Duration(seconds: 1));

    //data dummy
    return DashboardData(
      userName: 'Admin D4TI',
      lastUpdate: DateTime.now(),
      stats: [
        DashboardStats(
          title: 'Total Mahasiswa',
          value: '1,200',
          subtitle: '',
          // percentage: 8.5,
          // isIncrease: true,
        ),
        DashboardStats(
          title: 'Mahasiswa Aktif',
          value: '550',
          subtitle: '',
          // percentage: 5.2,
          // isIncrease: true,
        ),
        DashboardStats(
          title: 'Dosen',
          value: '650',
          subtitle: '',
          // percentage: 2.1,
          // isIncrease: false,
        ),
        DashboardStats(
          title: 'Profile',
          value: '',
          subtitle: '',
          // percentage: 3.5,
          // isIncrease: true,
        ),
      ],
    );
  }

  // refresh dashboard data
  Future<DashboardData> refreshDashboard() async {
    return getDashboardData();
  }

  //get specific stat by title
  Future<DashboardStats?> getStatByTitle(String title) async {
    final data = await getDashboardData();
    try {
      return data.stats.firstWhere((stat) => stat.title == title);
    } catch (e) {
      return null;
    }
  }
}