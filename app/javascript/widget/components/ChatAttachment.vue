<script>
import FileUpload from 'vue-upload-component';
import Spinner from 'shared/components/Spinner.vue';
<<<<<<< HEAD
import { checkFileSizeLimit } from 'shared/helpers/FileHelper';
import {
  MAXIMUM_FILE_UPLOAD_SIZE,
  ALLOWED_FILE_TYPES,
} from 'shared/constants/messages';
=======
import {
  checkFileSizeLimit,
  resolveMaximumFileUploadSize,
} from 'shared/helpers/FileHelper';
import { ALLOWED_FILE_TYPES } from 'shared/constants/messages';
>>>>>>> upstream/develop
import { BUS_EVENTS } from 'shared/constants/busEvents';
import FluentIcon from 'shared/components/FluentIcon/Index.vue';
import { DirectUpload } from 'activestorage';
import { mapGetters } from 'vuex';
import { emitter } from 'shared/helpers/mitt';
<<<<<<< HEAD
=======
import { useAttachments } from '../composables/useAttachments';
>>>>>>> upstream/develop

export default {
  components: { FluentIcon, FileUpload, Spinner },
  props: {
    onAttach: {
      type: Function,
      default: () => {},
    },
  },
<<<<<<< HEAD
=======
  setup() {
    const { canHandleAttachments } = useAttachments();
    return { canHandleAttachments };
  },
>>>>>>> upstream/develop
  data() {
    return { isUploading: false };
  },
  computed: {
<<<<<<< HEAD
    ...mapGetters({ globalConfig: 'globalConfig/get' }),
    fileUploadSizeLimit() {
      return MAXIMUM_FILE_UPLOAD_SIZE;
=======
    ...mapGetters({
      globalConfig: 'globalConfig/get',
    }),
    fileUploadSizeLimit() {
      return resolveMaximumFileUploadSize(
        this.globalConfig.maximumFileUploadSize
      );
>>>>>>> upstream/develop
    },
    allowedFileTypes() {
      return ALLOWED_FILE_TYPES;
    },
  },
  mounted() {
    document.addEventListener('paste', this.handleClipboardPaste);
  },
  unmounted() {
    document.removeEventListener('paste', this.handleClipboardPaste);
  },
  methods: {
    handleClipboardPaste(e) {
<<<<<<< HEAD
=======
      // If file picker is not enabled, do not allow paste
      if (!this.canHandleAttachments) return;

>>>>>>> upstream/develop
      const items = (e.clipboardData || e.originalEvent.clipboardData).items;
      // items is a DataTransferItemList object which does not have forEach method
      const itemsArray = Array.from(items);
      itemsArray.forEach(item => {
        if (item.kind === 'file') {
          e.preventDefault();
          const file = item.getAsFile();
          this.$refs.upload.add(file);
        }
      });
    },
    getFileType(fileType) {
      return fileType.includes('image') ? 'image' : 'file';
    },
    async onFileUpload(file) {
      if (this.globalConfig.directUploadsEnabled) {
        await this.onDirectFileUpload(file);
      } else {
        await this.onIndirectFileUpload(file);
      }
    },
    async onDirectFileUpload(file) {
      if (!file) {
        return;
      }
      this.isUploading = true;
      try {
<<<<<<< HEAD
        if (checkFileSizeLimit(file, MAXIMUM_FILE_UPLOAD_SIZE)) {
=======
        if (checkFileSizeLimit(file, this.fileUploadSizeLimit)) {
>>>>>>> upstream/develop
          const { websiteToken } = window.chatwootWebChannel;
          const upload = new DirectUpload(
            file.file,
            `/api/v1/widget/direct_uploads?website_token=${websiteToken}`,
            {
              directUploadWillCreateBlobWithXHR: xhr => {
                xhr.setRequestHeader('X-Auth-Token', window.authToken);
              },
            }
          );

          upload.create((error, blob) => {
            if (error) {
              emitter.emit(BUS_EVENTS.SHOW_ALERT, {
                message: error,
              });
            } else {
              this.onAttach({
                file: blob.signed_id,
                ...this.getLocalFileAttributes(file),
              });
            }
          });
        } else {
          emitter.emit(BUS_EVENTS.SHOW_ALERT, {
            message: this.$t('FILE_SIZE_LIMIT', {
              MAXIMUM_FILE_UPLOAD_SIZE: this.fileUploadSizeLimit,
            }),
          });
        }
      } catch (error) {
        // Error
      }
      this.isUploading = false;
    },
    async onIndirectFileUpload(file) {
      if (!file) {
        return;
      }
      this.isUploading = true;
      try {
<<<<<<< HEAD
        if (checkFileSizeLimit(file, MAXIMUM_FILE_UPLOAD_SIZE)) {
=======
        if (checkFileSizeLimit(file, this.fileUploadSizeLimit)) {
>>>>>>> upstream/develop
          await this.onAttach({
            file: file.file,
            ...this.getLocalFileAttributes(file),
          });
        } else {
          emitter.emit(BUS_EVENTS.SHOW_ALERT, {
            message: this.$t('FILE_SIZE_LIMIT', {
              MAXIMUM_FILE_UPLOAD_SIZE: this.fileUploadSizeLimit,
            }),
          });
        }
      } catch (error) {
        // Error
      }
      this.isUploading = false;
    },
    getLocalFileAttributes(file) {
      return {
        thumbUrl: window.URL.createObjectURL(file.file),
        fileType: this.getFileType(file.type),
      };
    },
  },
};
</script>

<template>
  <FileUpload
    ref="upload"
    :size="4096 * 2048"
    :accept="allowedFileTypes"
    :data="{
      direct_upload_url: '/api/v1/widget/direct_uploads',
      direct_upload: true,
    }"
    @input-file="onFileUpload"
  >
    <button class="min-h-8 min-w-8 flex items-center justify-center">
      <FluentIcon v-if="!isUploading.image" icon="attach" />
      <Spinner v-if="isUploading" size="small" />
    </button>
  </FileUpload>
</template>
