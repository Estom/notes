package cn.aofeng.demo.dbutils;

/**
 * 表student的POJO对象。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Student {

    private Integer userId;
    
    private String userName;
    
    private String gender;
    
    private Integer age;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((age == null) ? 0 : age.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (!(obj instanceof Student)) {
            return false;
        }
        Student other = (Student) obj;
        if (age == null) {
            if (other.age != null) {
                return false;
            }
        } else if (!age.equals(other.age)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Student [userId=" + userId + ", userName=" + userName
                + ", gender=" + gender + ", age=" + age + "]";
    }

}
