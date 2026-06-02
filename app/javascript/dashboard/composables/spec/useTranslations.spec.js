<<<<<<< HEAD
import { ref } from 'vue';
import { useTranslations } from '../useTranslations';

describe('useTranslations', () => {
  it('returns false and null when contentAttributes is null', () => {
    const contentAttributes = ref(null);
    const { hasTranslations, translationContent } =
      useTranslations(contentAttributes);
    expect(hasTranslations.value).toBe(false);
    expect(translationContent.value).toBeNull();
  });

  it('returns false and null when translations are missing', () => {
    const contentAttributes = ref({});
    const { hasTranslations, translationContent } =
      useTranslations(contentAttributes);
    expect(hasTranslations.value).toBe(false);
    expect(translationContent.value).toBeNull();
  });

  it('returns false and null when translations is an empty object', () => {
    const contentAttributes = ref({ translations: {} });
    const { hasTranslations, translationContent } =
      useTranslations(contentAttributes);
    expect(hasTranslations.value).toBe(false);
    expect(translationContent.value).toBeNull();
  });

  it('returns true and correct translation content when translations exist', () => {
    const contentAttributes = ref({
      translations: { en: 'Hello' },
    });
    const { hasTranslations, translationContent } =
      useTranslations(contentAttributes);
    expect(hasTranslations.value).toBe(true);
    // Should return the first translation (en: 'Hello')
    expect(translationContent.value).toBe('Hello');
=======
import { selectTranslation } from '../useTranslations';

describe('selectTranslation', () => {
  it('returns null when translations is null', () => {
    expect(selectTranslation(null, 'en', 'en')).toBeNull();
  });

  it('returns null when translations is empty', () => {
    expect(selectTranslation({}, 'en', 'en')).toBeNull();
  });

  it('returns first translation when no locale matches', () => {
    const translations = { en: 'Hello', es: 'Hola' };
    expect(selectTranslation(translations, 'fr', 'de')).toBe('Hello');
  });

  it('returns translation matching agent locale', () => {
    const translations = { en: 'Hello', es: 'Hola', zh_CN: '你好' };
    expect(selectTranslation(translations, 'es', 'en')).toBe('Hola');
  });

  it('falls back to account locale when agent locale not found', () => {
    const translations = { en: 'Hello', zh_CN: '你好' };
    expect(selectTranslation(translations, 'fr', 'zh_CN')).toBe('你好');
  });

  it('returns first translation when both locales are undefined', () => {
    const translations = { en: 'Hello', es: 'Hola' };
    expect(selectTranslation(translations, undefined, undefined)).toBe('Hello');
>>>>>>> upstream/develop
  });
});
