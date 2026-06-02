import {
  setAuthCredentials,
  throwErrorMessage,
  clearLocalStorageOnLogout,
<<<<<<< HEAD
} from 'dashboard/store/utils/api';
import wootAPI from './apiClient';
import { getLoginRedirectURL } from '../helpers/AuthHelper';
=======
  parseAPIErrorResponse,
} from 'dashboard/store/utils/api';
import wootAPI from './apiClient';
import {
  getLoginRedirectURL,
  getCredentialsFromEmail,
} from '../helpers/AuthHelper';
>>>>>>> upstream/develop

export const login = async ({
  ssoAccountId,
  ssoConversationId,
  ...credentials
}) => {
  try {
    const response = await wootAPI.post('auth/sign_in', credentials);
<<<<<<< HEAD
=======

    // Check if MFA is required
    if (response.status === 206 && response.data.mfa_required) {
      // Return MFA data instead of throwing error
      return {
        mfaRequired: true,
        mfaToken: response.data.mfa_token,
      };
    }

>>>>>>> upstream/develop
    setAuthCredentials(response);
    clearLocalStorageOnLogout();
    window.location = getLoginRedirectURL({
      ssoAccountId,
      ssoConversationId,
      user: response.data.data,
    });
<<<<<<< HEAD
  } catch (error) {
    throwErrorMessage(error);
=======
    return null;
  } catch (error) {
    // Check if it's an MFA required response
    if (error.response?.status === 206 && error.response?.data?.mfa_required) {
      return {
        mfaRequired: true,
        mfaToken: error.response.data.mfa_token,
      };
    }
    const loginError = new Error(parseAPIErrorResponse(error));
    loginError.errorCode = error.response?.data?.error_code;
    throw loginError;
>>>>>>> upstream/develop
  }
};

export const register = async creds => {
  try {
<<<<<<< HEAD
    const response = await wootAPI.post('api/v1/accounts.json', {
      account_name: creds.accountName.trim(),
      user_full_name: creds.fullName.trim(),
=======
    const { fullName, accountName } = getCredentialsFromEmail(creds.email);
    const response = await wootAPI.post('api/v1/accounts.json', {
      account_name: accountName,
      user_full_name: fullName,
>>>>>>> upstream/develop
      email: creds.email,
      password: creds.password,
      h_captcha_client_response: creds.hCaptchaClientResponse,
    });
<<<<<<< HEAD
    setAuthCredentials(response);
=======
>>>>>>> upstream/develop
    return response.data;
  } catch (error) {
    throwErrorMessage(error);
  }
  return null;
};

<<<<<<< HEAD
=======
export const resendConfirmation = async ({ email, hCaptchaClientResponse }) => {
  return wootAPI.post('resend_confirmation', {
    email,
    h_captcha_client_response: hCaptchaClientResponse,
  });
};

>>>>>>> upstream/develop
export const verifyPasswordToken = async ({ confirmationToken }) => {
  try {
    const response = await wootAPI.post('auth/confirmation', {
      confirmation_token: confirmationToken,
    });
    setAuthCredentials(response);
  } catch (error) {
    throwErrorMessage(error);
  }
};

export const setNewPassword = async ({
  resetPasswordToken,
  password,
  confirmPassword,
}) => {
  try {
    const response = await wootAPI.put('auth/password', {
      reset_password_token: resetPasswordToken,
      password_confirmation: confirmPassword,
      password,
    });
    setAuthCredentials(response);
  } catch (error) {
    throwErrorMessage(error);
  }
};

export const resetPassword = async ({ email }) =>
  wootAPI.post('auth/password', { email });
