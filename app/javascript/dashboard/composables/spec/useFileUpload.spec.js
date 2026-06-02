import { useFileUpload } from '../useFileUpload';
import { useMapGetter } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { DirectUpload } from 'activestorage';
import { checkFileSizeLimit } from 'shared/helpers/FileHelper';
<<<<<<< HEAD
import { MAXIMUM_FILE_UPLOAD_SIZE_TWILIO_SMS_CHANNEL } from 'shared/constants/messages';
=======
import { getMaxUploadSizeByChannel } from '@chatwoot/utils';
>>>>>>> upstream/develop

vi.mock('dashboard/composables/store');
vi.mock('dashboard/composables', () => ({
  useAlert: vi.fn(message => message),
}));
vi.mock('vue-i18n');
vi.mock('activestorage');
<<<<<<< HEAD
vi.mock('shared/helpers/FileHelper');
=======
vi.mock('shared/helpers/FileHelper', () => ({
  checkFileSizeLimit: vi.fn(),
  resolveMaximumFileUploadSize: vi.fn(value => Number(value) || 40),
  DEFAULT_MAXIMUM_FILE_UPLOAD_SIZE: 40,
}));
vi.mock('@chatwoot/utils');
>>>>>>> upstream/develop

describe('useFileUpload', () => {
  const mockAttachFile = vi.fn();
  const mockTranslate = vi.fn();

  const mockFile = {
    file: new File(['test'], 'test.jpg', { type: 'image/jpeg' }),
  };

<<<<<<< HEAD
=======
  const inbox = {
    channel_type: 'Channel::WhatsApp',
    medium: 'whatsapp',
  };

>>>>>>> upstream/develop
  beforeEach(() => {
    vi.clearAllMocks();

    useMapGetter.mockImplementation(getter => {
      const getterMap = {
        getCurrentAccountId: { value: '123' },
        getCurrentUser: { value: { access_token: 'test-token' } },
        getSelectedChat: { value: { id: '456' } },
<<<<<<< HEAD
        'globalConfig/get': { value: { directUploadsEnabled: true } },
=======
        'globalConfig/get': {
          value: { directUploadsEnabled: true, maximumFileUploadSize: 40 },
        },
>>>>>>> upstream/develop
      };
      return getterMap[getter];
    });

    useI18n.mockReturnValue({ t: mockTranslate });
    checkFileSizeLimit.mockReturnValue(true);
<<<<<<< HEAD
  });

  it('should handle direct file upload when enabled', () => {
    const { onFileUpload } = useFileUpload({
      isATwilioSMSChannel: false,
=======
    getMaxUploadSizeByChannel.mockReturnValue(25); // default max size MB for tests
  });

  it('handles direct file upload when direct uploads enabled', () => {
    const { onFileUpload } = useFileUpload({
      inbox,
>>>>>>> upstream/develop
      attachFile: mockAttachFile,
    });

    const mockBlob = { signed_id: 'test-blob' };
    DirectUpload.mockImplementation(() => ({
      create: callback => callback(null, mockBlob),
    }));

    onFileUpload(mockFile);

<<<<<<< HEAD
=======
    // size rules called with inbox + mime
    expect(getMaxUploadSizeByChannel).toHaveBeenCalledWith({
      channelType: inbox.channel_type,
      medium: inbox.medium,
      mime: 'image/jpeg',
    });

    // size check called with max from helper
    expect(checkFileSizeLimit).toHaveBeenCalledWith(mockFile, 25);

>>>>>>> upstream/develop
    expect(DirectUpload).toHaveBeenCalledWith(
      mockFile.file,
      '/api/v1/accounts/123/conversations/456/direct_uploads',
      expect.any(Object)
    );
    expect(mockAttachFile).toHaveBeenCalledWith({
      file: mockFile,
      blob: mockBlob,
    });
  });

<<<<<<< HEAD
  it('should handle indirect file upload when direct upload is disabled', () => {
=======
  it('handles indirect file upload when direct upload disabled', () => {
>>>>>>> upstream/develop
    useMapGetter.mockImplementation(getter => {
      const getterMap = {
        getCurrentAccountId: { value: '123' },
        getCurrentUser: { value: { access_token: 'test-token' } },
        getSelectedChat: { value: { id: '456' } },
<<<<<<< HEAD
        'globalConfig/get': { value: { directUploadsEnabled: false } },
=======
        'globalConfig/get': {
          value: { directUploadsEnabled: false, maximumFileUploadSize: 40 },
        },
>>>>>>> upstream/develop
      };
      return getterMap[getter];
    });

    const { onFileUpload } = useFileUpload({
<<<<<<< HEAD
      isATwilioSMSChannel: false,
=======
      inbox,
>>>>>>> upstream/develop
      attachFile: mockAttachFile,
    });

    onFileUpload(mockFile);

    expect(DirectUpload).not.toHaveBeenCalled();
<<<<<<< HEAD
    expect(mockAttachFile).toHaveBeenCalledWith({ file: mockFile });
  });

  it('should show alert when file size exceeds limit', () => {
=======
    expect(getMaxUploadSizeByChannel).toHaveBeenCalled();
    expect(checkFileSizeLimit).toHaveBeenCalledWith(mockFile, 25);
    expect(mockAttachFile).toHaveBeenCalledWith({ file: mockFile });
  });

  it('shows alert when file size exceeds limit', () => {
>>>>>>> upstream/develop
    checkFileSizeLimit.mockReturnValue(false);
    mockTranslate.mockReturnValue('File size exceeds limit');

    const { onFileUpload } = useFileUpload({
<<<<<<< HEAD
      isATwilioSMSChannel: false,
=======
      inbox,
>>>>>>> upstream/develop
      attachFile: mockAttachFile,
    });

    onFileUpload(mockFile);

    expect(useAlert).toHaveBeenCalledWith('File size exceeds limit');
    expect(mockAttachFile).not.toHaveBeenCalled();
  });

<<<<<<< HEAD
  it('should use different max file size for Twilio SMS channel', () => {
    const { onFileUpload } = useFileUpload({
      isATwilioSMSChannel: true,
      attachFile: mockAttachFile,
    });

    onFileUpload(mockFile);

    expect(checkFileSizeLimit).toHaveBeenCalledWith(
      mockFile,
      MAXIMUM_FILE_UPLOAD_SIZE_TWILIO_SMS_CHANNEL
    );
  });

  it('should handle direct upload errors', () => {
=======
  it('uses per-mime limits from helper', () => {
    getMaxUploadSizeByChannel.mockImplementation(({ mime }) =>
      mime.startsWith('image/') ? 10 : 50
    );
    const { onFileUpload } = useFileUpload({
      inbox,
      attachFile: mockAttachFile,
    });

    DirectUpload.mockImplementation(() => ({
      create: cb => cb(null, { signed_id: 'blob' }),
    }));

    onFileUpload(mockFile);

    expect(getMaxUploadSizeByChannel).toHaveBeenCalledWith({
      channelType: inbox.channel_type,
      medium: inbox.medium,
      mime: 'image/jpeg',
    });
    expect(checkFileSizeLimit).toHaveBeenCalledWith(mockFile, 10);
  });

  it('handles direct upload errors', () => {
>>>>>>> upstream/develop
    const mockError = 'Upload failed';
    DirectUpload.mockImplementation(() => ({
      create: callback => callback(mockError, null),
    }));

    const { onFileUpload } = useFileUpload({
<<<<<<< HEAD
      isATwilioSMSChannel: false,
=======
      inbox,
>>>>>>> upstream/develop
      attachFile: mockAttachFile,
    });

    onFileUpload(mockFile);

    expect(useAlert).toHaveBeenCalledWith(mockError);
    expect(mockAttachFile).not.toHaveBeenCalled();
  });

<<<<<<< HEAD
  it('should do nothing when file is null', () => {
    const { onFileUpload } = useFileUpload({
      isATwilioSMSChannel: false,
=======
  it('does nothing when file is null', () => {
    const { onFileUpload } = useFileUpload({
      inbox,
>>>>>>> upstream/develop
      attachFile: mockAttachFile,
    });

    onFileUpload(null);

    expect(checkFileSizeLimit).not.toHaveBeenCalled();
<<<<<<< HEAD
=======
    expect(getMaxUploadSizeByChannel).not.toHaveBeenCalled();
>>>>>>> upstream/develop
    expect(mockAttachFile).not.toHaveBeenCalled();
    expect(useAlert).not.toHaveBeenCalled();
  });
});
