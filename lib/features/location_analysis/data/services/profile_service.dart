import 'package:hive/hive.dart';
import '../../domain/models/profile_model.dart';

class ProfileService {
  // Singleton pattern
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  late Box<ProfileModel> _box;
  static const String _boxName = 'profile';
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    // Zaten başlatılmışsa tekrar başlatma
    if (_isInitialized) return;

    try {
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(ProfileModelAdapter());
      }
      _box = await Hive.openBox<ProfileModel>(_boxName);

      // İlk kez açılıyorsa varsayılan değerleri ayarla
      if (_box.isEmpty) {
        await _box.put('user', ProfileModel(
          name: 'Mogi User',
          city: 'İstanbul',
        ));
      }
      
      _isInitialized = true;
    } catch (e) {
      print('ProfileService init error: $e');
      // Hata durumunda yeniden deneme veya alternatif init metodu
      rethrow; // Üst katmanda işlenebilmesi için hatayı yeniden fırlat
    }
  }

  Future<ProfileModel?> getProfile() async {
    // Başlatılmamışsa başlat
    if (!_isInitialized) await init();
    
    try {
      return _box.get('user');
    } catch (e) {
      print('Error getting profile: $e');
      return null; // Hata durumunda null dön
    }
  }

  /// Updates profile information
  /// 
  /// [name] and [city] parameters are required.
  /// Validation is performed for empty values, invalid characters, or values that are too long.
  /// 
  /// Returns [true] if successful, [false] if unsuccessful.
  /// Throws [ValidationException] in case of validation errors.
  Future<bool> updateProfile({
    required String name,
    required String city,
  }) async {
    // Başlatılmamışsa başlat
    if (!_isInitialized) await init();
    
    try {
      // Boş değer kontrolü
      if (name.trim().isEmpty) {
        throw ValidationException('Name cannot be empty');
      }
      
      if (city.trim().isEmpty) {
        throw ValidationException('City cannot be empty');
      }
      
      // Minimum uzunluk kontrolü
      if (name.trim().length < 2) {
        throw ValidationException('Name must be at least 2 characters');
      }
      
      if (city.trim().length < 2) {
        throw ValidationException('City must be at least 2 characters');
      }
      
      // Geçersiz karakter kontrolü - sadece sayıları kontrol et
      final hasNumbers = RegExp(r'[0-9]');
      if (hasNumbers.hasMatch(name)) {
        throw ValidationException('Name cannot contain numbers');
      }
      
      if (hasNumbers.hasMatch(city)) {
        throw ValidationException('City cannot contain numbers');
      }
      
      // Çok uzun değerleri kırp
      final trimmedName = name.trim().length > 50 ? name.trim().substring(0, 50) : name.trim();
      final trimmedCity = city.trim().length > 50 ? city.trim().substring(0, 50) : city.trim();
      
      // Veritabanına kaydet
      await _box.put('user', ProfileModel(
        name: trimmedName,
        city: trimmedCity,
      ));
      
      return true; // Başarılı işlem
    } on ValidationException catch (e) {
      print('Profile validation error: ${e.message}');
      rethrow; // Validasyon hatasını üst katmana ilet
    } catch (e) {
      print('Error updating profile: $e');
      return false; // Diğer hatalar için false dön
    }
  }

  // Profili sıfırla (taşma sorununu çözmek için)
  Future<bool> resetProfile() async {
    // Başlatılmamışsa başlat
    if (!_isInitialized) await init();
    
    try {
      await _box.put('user', ProfileModel(
        name: 'Mogi User',
        city: 'İstanbul',
      ));
      return true; // Başarılı işlem
    } catch (e) {
      print('Error resetting profile: $e');
      return false; // Hata durumunda false dön
    }
  }
  
  // Kaynakları temizle
  Future<void> dispose() async {
    if (_isInitialized && _box.isOpen) {
      await _box.close();
      _isInitialized = false;
    }
  }
}

/// Custom exception class representing validation errors
class ValidationException implements Exception {
  final String message;
  
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
} 