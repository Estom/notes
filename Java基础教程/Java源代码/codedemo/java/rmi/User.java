package cn.aofeng.demo.java.rmi;

import java.io.Serializable;

/**
 * 用户信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class User implements Serializable {

    private static final long serialVersionUID = 7616705579045104892L;

    /**
     * 身份证号。
     */
    private String id;
    
    /**
     * 姓名。
     */
    private String name;
    
    /**
     * 性别：M-男；F-女。
     */
    private char gender;

    /**
     * 出生日期。以毫秒存储。
     */
    private long birthday;
    
    /**
     * 国家。
     */
    private String country;
    
    /**
     * 省／州。
     */
    private String province;
    
    /**
     * 市／区。
     */
    private String city;
    
    /**
     * 街道详细地址。
     */
    private String address;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public char getGender() {
        return gender;
    }

    public void setGender(char gender) {
        this.gender = gender;
    }

    public long getBirthday() {
        return birthday;
    }

    public void setBirthday(long birthday) {
        this.birthday = birthday;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((country == null) ? 0 : country.hashCode());
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        User other = (User) obj;
        if (country == null) {
            if (other.country != null)
                return false;
        } else if (!country.equals(other.country))
            return false;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (name == null) {
            if (other.name != null)
                return false;
        } else if (!name.equals(other.name))
            return false;
        return true;
    }

    @Override
    public String toString() {
        StringBuilder buffer = new StringBuilder(256)
            .append("User [id=").append(id)
            .append(", name=").append(name)
            .append(", gender=").append(gender)
            .append(", birthday=").append(birthday)
            .append(", country=").append(country)
            .append(", province=").append(province)
            .append(", city=").append(city)
            .append(", address=").append(address)
            .append("]");
        return buffer.toString();
    }

}
