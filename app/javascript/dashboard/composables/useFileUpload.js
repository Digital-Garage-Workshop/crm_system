<<<<<<< HEAD
import { computed } from 'vue';
=======
>>>>>>> upstream/develop
import { useMapGetter } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { DirectUpload } from 'activestorage';
<<<<<<< HEAD
import {
  MAXIMUM_FILE_UPLOAD_SIZE,
  MAXIMUM_FILE_UPLOAD_SIZE_TWILIO_SMS_CHANNEL,
} from 'shared/constants/messages';
import { checkFileSizeLimit } from 'shared/helpers/FileHelper';

/**
 * Composable for handling file uploads in conversations
 * @param {Object} options - Configuration options
 * @param {boolean} options.isATwilioSMSChannel - Whether the current channel is Twilio SMS
 * @param {Function} options.attachFile - Callback function to handle file attachment
 * @returns {Object} File upload methods and utilities
 */
export const useFileUpload = ({ isATwilioSMSChannel, attachFile }) => {
=======
import { checkFileSizeLimit } from 'shared/helpers/FileHelper';
import { getMaxUploadSizeByChannel } from '@chatwoot/utils';
import {
  DEFAULT_MAXIMUM_FILE_UPLOAD_SIZE,
  resolveMaximumFileUploadSize,
} from 'shared/helpers/FileHelper';
import { INBOX_TYPES } from 'dashboard/helper/inbox';

/**
 * Composable for handling file uploads in conversations
 * @param {Object} options
 * @param {Object} options.inbox - Current inbox object (has channel_type, medium, etc.)
 * @param {Function} options.attachFile - Callback to handle file attachment
 * @param {boolean} options.isPrivateNote - Whether the upload is for a private note
 */
export const useFileUpload = ({ inbox, attachFile, isPrivateNote = false }) => {
>>>>>>> upstream/develop
  const { t } = useI18n();

  const accountId = useMapGetter('getCurrentAccountId');
  const currentUser = useMapGetter('getCurrentUser');
  const currentChat = useMapGetter('getSelectedChat');
  const globalConfig = useMapGetter('globalConfig/get');

<<<<<<< HEAD
  const maxFileSize = computed(() =>
    isATwilioSMSChannel
      ? MAXIMUM_FILE_UPLOAD_SIZE_TWILIO_SMS_CHANNEL
      : MAXIMUM_FILE_UPLOAD_SIZE
  );

  const handleDirectFileUpload = file => {
    if (!file) return;

    if (checkFileSizeLimit(file, maxFileSize.value)) {
      const upload = new DirectUpload(
        file.file,
        `/api/v1/accounts/${accountId.value}/conversations/${currentChat.value.id}/direct_uploads`,
        {
          directUploadWillCreateBlobWithXHR: xhr => {
            xhr.setRequestHeader(
              'api_access_token',
              currentUser.value.access_token
            );
          },
        }
      );

      upload.create((error, blob) => {
        if (error) {
          useAlert(error);
        } else {
          attachFile({ file, blob });
        }
      });
    } else {
      useAlert(
        t('CONVERSATION.FILE_SIZE_LIMIT', {
          MAXIMUM_SUPPORTED_FILE_UPLOAD_SIZE: maxFileSize.value,
        })
      );
    }
=======
  const installationLimit = resolveMaximumFileUploadSize(
    globalConfig.value?.maximumFileUploadSize
  );

  // helper: compute max upload size for a given file's mime
  const maxSizeFor = mime => {
    // Use default/installation limit for private notes
    if (isPrivateNote) {
      return installationLimit;
    }

    const channelType = inbox?.channel_type;

    if (!channelType || channelType === INBOX_TYPES.WEB) {
      return installationLimit;
    }

    const channelLimit = getMaxUploadSizeByChannel({
      channelType,
      medium: inbox?.medium, // e.g. 'sms' | 'whatsapp' | etc.
      mime, // e.g. 'image/png'
    });

    if (channelLimit === DEFAULT_MAXIMUM_FILE_UPLOAD_SIZE) {
      return installationLimit;
    }

    return Math.min(channelLimit, installationLimit);
  };

  const alertOverLimit = maxSizeMB =>
    useAlert(
      t('CONVERSATION.FILE_SIZE_LIMIT', {
        MAXIMUM_SUPPORTED_FILE_UPLOAD_SIZE: maxSizeMB,
      })
    );

  const handleDirectFileUpload = file => {
    if (!file) return;

    const mime = file.file?.type || file.type;
    const maxSizeMB = maxSizeFor(mime);

    if (!checkFileSizeLimit(file, maxSizeMB)) {
      alertOverLimit(maxSizeMB);
      return;
    }

    const upload = new DirectUpload(
      file.file,
      `/api/v1/accounts/${accountId.value}/conversations/${currentChat.value.id}/direct_uploads`,
      {
        directUploadWillCreateBlobWithXHR: xhr => {
          xhr.setRequestHeader(
            'api_access_token',
            currentUser.value.access_token
          );
        },
      }
    );

    upload.create((error, blob) => {
      if (error) {
        useAlert(error);
      } else {
        attachFile({ file, blob });
      }
    });
>>>>>>> upstream/develop
  };

  const handleIndirectFileUpload = file => {
    if (!file) return;

<<<<<<< HEAD
    if (checkFileSizeLimit(file, maxFileSize.value)) {
      attachFile({ file });
    } else {
      useAlert(
        t('CONVERSATION.FILE_SIZE_LIMIT', {
          MAXIMUM_SUPPORTED_FILE_UPLOAD_SIZE: maxFileSize.value,
        })
      );
    }
=======
    const mime = file.file?.type || file.type;
    const maxSizeMB = maxSizeFor(mime);

    if (!checkFileSizeLimit(file, maxSizeMB)) {
      alertOverLimit(maxSizeMB);
      return;
    }

    attachFile({ file });
>>>>>>> upstream/develop
  };

  const onFileUpload = file => {
    if (globalConfig.value.directUploadsEnabled) {
      handleDirectFileUpload(file);
    } else {
      handleIndirectFileUpload(file);
    }
  };

<<<<<<< HEAD
  return {
    onFileUpload,
  };
=======
  return { onFileUpload };
>>>>>>> upstream/develop
};
