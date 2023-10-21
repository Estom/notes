package cn.aofeng.demo.encrypt;

import static cn.aofeng.demo.util.LogUtil.log;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

import org.apache.commons.codec.binary.Base64;

/**
 * AES加密与解密。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class AES extends EncryptAndDecrypt {

    public final String encryptType = "AES/CBC/PKCS5Padding";
    public final String algorithmParam = "abcdefgh12345678";
    public final String key = "abcdefgh_1234567";

    public void execute(String data) throws InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        SecretKey secretKey = createSecretKey("AES", key);
        byte[] secretData = encrypt(encryptType, secretKey, data,
                algorithmParam);
        log("使用%s加密后的数据：", encryptType);
        log(Base64.encodeBase64String(secretData));

        String srcStr = decrypt(encryptType, secretKey, secretData,
                algorithmParam);
        log("解密后的数据：\n%s", srcStr);
    }

    public static void main(String[] args) throws UnsupportedEncodingException,
            InvalidKeyException, IllegalBlockSizeException,
            BadPaddingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        String data = "炎黄，汉字，english,do it,abcdefghijklmnopqrstuvwxyz,0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ, ~!@#$%^&*()_+=-";
        log("待加密的数据：\n%s", data);

        AES aes = new AES();
        aes.execute(data);
    }

}
