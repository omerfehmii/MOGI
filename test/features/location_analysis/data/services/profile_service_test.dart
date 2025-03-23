import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mogi/features/location_analysis/data/services/profile_service.dart';
import 'package:mogi/features/location_analysis/domain/models/profile_model.dart';

void main() {
  late ProfileService profileService;

  setUpAll(() async {
    // Test için Hive'ı hazırla
    await setUpTestHive();
    
    // Adapter'ı kaydetmeyi dene, zaten kayıtlıysa hata verme
    try {
      Hive.registerAdapter(ProfileModelAdapter());
    } catch (e) {
      // Adapter zaten kayıtlı, görmezden gel
    }
  });

  setUp(() async {
    // Her test için yeni bir ProfileService örneği oluştur
    profileService = ProfileService();
    
    // Önceki testlerden kalan durumu temizle
    try {
      await profileService.dispose();
    } catch (e) {
      // Görmezden gel
    }
    
    // Servisi başlat
    await profileService.init();
  });

  tearDown(() async {
    // Test sonrası temizlik
    try {
      await profileService.dispose();
    } catch (e) {
      // Görmezden gel
    }
  });

  tearDownAll(() async {
    // Tüm testler sonrası temizlik
    await tearDownTestHive();
  });

  group('ProfileService Tests', () {
    test('init should create default profile if box is empty', () async {
      // ProfileService init metodu setUp'ta çağrıldı
      final profile = await profileService.getProfile();
      
      // Varsayılan değerleri kontrol et
      expect(profile, isNotNull);
      expect(profile!.name, equals('Mogi User'));
      expect(profile.city, equals('İstanbul'));
    });

    test('updateProfile should update profile data', () async {
      // Profili güncelle
      final result = await profileService.updateProfile(
        name: 'Test User',
        city: 'Berlin',
      );
      
      // Güncelleme başarılı olmalı
      expect(result, isTrue);
      
      // Güncellenmiş profili al ve kontrol et
      final updatedProfile = await profileService.getProfile();
      expect(updatedProfile, isNotNull);
      expect(updatedProfile!.name, equals('Test User'));
      expect(updatedProfile.city, equals('Berlin'));
    });

    test('updateProfile should trim long values', () async {
      // Çok uzun değerlerle profili güncelle
      final longName = 'A' * 100; // 100 karakter uzunluğunda
      final longCity = 'B' * 100; // 100 karakter uzunluğunda
      
      final result = await profileService.updateProfile(
        name: longName,
        city: longCity,
      );
      
      // Güncelleme başarılı olmalı
      expect(result, isTrue);
      
      // Kırpılmış değerleri kontrol et
      final updatedProfile = await profileService.getProfile();
      expect(updatedProfile, isNotNull);
      expect(updatedProfile!.name.length, equals(50));
      expect(updatedProfile.city.length, equals(50));
    });

    test('resetProfile should restore default values', () async {
      // Önce profili güncelle
      await profileService.updateProfile(
        name: 'Test User',
        city: 'Berlin',
      );
      
      // Sonra sıfırla
      final result = await profileService.resetProfile();
      
      // Sıfırlama başarılı olmalı
      expect(result, isTrue);
      
      // Varsayılan değerlere dönüp dönmediğini kontrol et
      final resetProfile = await profileService.getProfile();
      expect(resetProfile, isNotNull);
      expect(resetProfile!.name, equals('Mogi User'));
      expect(resetProfile.city, equals('İstanbul'));
    });

    test('getProfile should handle errors gracefully', () async {
      // Hata durumunu simüle etmek için servisi dispose et
      await profileService.dispose();
      
      // getProfile null dönmeli, çökme olmamalı
      final profile = await profileService.getProfile();
      
      // Servis otomatik olarak yeniden başlatılmalı
      expect(profile, isNotNull);
    });
    
    group('Validation Tests', () {
      test('should throw ValidationException for empty name', () async {
        // Boş isim ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: '', city: 'Berlin'),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'Name cannot be empty'
          ))
        );
      });
      
      test('should throw ValidationException for empty city', () async {
        // Boş şehir ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: 'Test User', city: ''),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'City cannot be empty'
          ))
        );
      });
      
      test('should throw ValidationException for too short name', () async {
        // Çok kısa isim ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: 'A', city: 'Berlin'),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'Name must be at least 2 characters'
          ))
        );
      });
      
      test('should throw ValidationException for too short city', () async {
        // Çok kısa şehir ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: 'Test User', city: 'B'),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'City must be at least 2 characters'
          ))
        );
      });
      
      test('should throw ValidationException for invalid name characters', () async {
        // Geçersiz karakterler içeren isim ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: 'Test123', city: 'Berlin'),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'Name cannot contain numbers'
          ))
        );
      });
      
      test('should throw ValidationException for invalid city characters', () async {
        // Geçersiz karakterler içeren şehir ile profil güncelleme
        expect(
          () => profileService.updateProfile(name: 'Test User', city: 'Berlin123'),
          throwsA(isA<ValidationException>().having(
            (e) => e.message, 
            'message', 
            'City cannot contain numbers'
          ))
        );
      });
      
      test('should trim whitespace from input', () async {
        // Başında ve sonunda boşluk olan değerlerle profil güncelleme
        final result = await profileService.updateProfile(
          name: '  Test User  ',
          city: '  Berlin  ',
        );
        
        // Güncelleme başarılı olmalı
        expect(result, isTrue);
        
        // Boşlukların kırpıldığını kontrol et
        final updatedProfile = await profileService.getProfile();
        expect(updatedProfile!.name, equals('Test User'));
        expect(updatedProfile.city, equals('Berlin'));
      });
    });
  });
} 