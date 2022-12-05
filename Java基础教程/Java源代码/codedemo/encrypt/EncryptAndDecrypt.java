package cn.aofeng.demo.encrypt;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * 加密与解密。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class EncryptAndDecrypt {

    public final static String CHARSET = "utf8";

    /**
     * 创建安全密钥。
     * 
     * @param encryptType
     *            加密方式，如：AES，Blowfish。详情查看<a href="https://docs.oracle.com/javase/7/docs/technotes/guides/security/StandardNames.html#Cipher">Java Cryptography Architecture Standard Algorithm Name Documentation</a>
     * @param keyStr
     *            密钥明文
     * @return 安全密钥
     * @throws UnsupportedEncodingException
     *             不支持指定的字符集编码
     */
    public SecretKey createSecretKey(String encryptType, String keyStr)
            throws UnsupportedEncodingException {
        byte[] secretKeyData = keyStr.getBytes(CHARSET);
        SecretKeySpec sks = new SecretKeySpec(secretKeyData, encryptType);

        return sks;
    }

    /**
     * 加密数据。
     * 
     * @param encryptType 加密方式，如：AES，Blowfish。详情查看<a href="https://docs.oracle.com/javase/7/docs/technotes/guides/security/StandardNames.html#Cipher">Java Cryptography Architecture Standard Algorithm Name Documentation</a>
     * @param secretKey 密钥
     * @param srcData 待加密的源数据
     * @return 加密后的二进制数据（字节数组）
     * @see #encrypt(String, SecretKey, String, String)
     */
    public byte[] encrypt(String encryptType, SecretKey secretKey,
            String srcData) throws InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        return encrypt(encryptType, secretKey, srcData, null);
    }

    /**
     * 加密数据。
     * 
     * @param encryptType 加密类型，如：AES/CBC/PKCS5Padding
     * @param secretKey 密钥
     * @param srcData 待加密的源数据
     * @param algorithmParam 某些加密算法的附加参数
     * @return 加密后的二进制数据（字节数组）
     */
    public byte[] encrypt(String encryptType, SecretKey secretKey,
            String srcData, String algorithmParam) throws InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        Cipher encrpyt = Cipher.getInstance(encryptType);
        if (null == algorithmParam) {
            encrpyt.init(Cipher.ENCRYPT_MODE, secretKey);
        } else {
            IvParameterSpec iv = new IvParameterSpec(
                    algorithmParam.getBytes(CHARSET));
            encrpyt.init(Cipher.ENCRYPT_MODE, secretKey, iv);
        }
        byte[] secretData = encrpyt.doFinal(srcData.getBytes(CHARSET));

        return secretData;
    }

    /**
     * 解密数据。
     * 
     * @param decryptType 解密方式，如：AES，Blowfish。详情查看<a href="https://docs.oracle.com/javase/7/docs/technotes/guides/security/StandardNames.html#Cipher">Java Cryptography Architecture Standard Algorithm Name Documentation</a>
     * @param secretKey 密钥
     * @param secretData 待解密的数据
     * @return 解密后的数据
     * @see #decrypt(String, SecretKey, byte[], String)
     */
    public String decrypt(String decryptType, SecretKey secretKey,
            byte[] secretData) throws InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        return decrypt(decryptType, secretKey, secretData, null);
    }

    public String decrypt(String decryptType, SecretKey secretKey,
            byte[] secretData, String algorithmParam)
            throws InvalidKeyException, IllegalBlockSizeException,
            BadPaddingException, UnsupportedEncodingException,
            NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidAlgorithmParameterException {
        Cipher decrypt = Cipher.getInstance(decryptType);
        if (null == algorithmParam) {
            decrypt.init(Cipher.DECRYPT_MODE, secretKey);
        } else {
            IvParameterSpec iv = new IvParameterSpec(
                    algorithmParam.getBytes(CHARSET));
            decrypt.init(Cipher.DECRYPT_MODE, secretKey, iv);
        }
        byte[] srcData = decrypt.doFinal(secretData);
        String srcStr = new String(srcData, CHARSET);

        return srcStr;
    }

}
