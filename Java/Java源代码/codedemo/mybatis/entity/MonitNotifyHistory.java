package cn.aofeng.demo.mybatis.entity;

/**
 * 监控通知历史实体类。 
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class MonitNotifyHistory {
    private Long recordId;

    private Integer monitId;

    private Integer appId;

    private Integer notifyType;

    private Integer notifyTarget;

    private String notifyContent;

    private Integer status;

    private Integer retryTimes;

    private Long createTime;

    public Long getRecordId() {
        return recordId;
    }

    public void setRecordId(Long recordId) {
        this.recordId = recordId;
    }

    public Integer getMonitId() {
        return monitId;
    }

    public void setMonitId(Integer monitId) {
        this.monitId = monitId;
    }

    public Integer getAppId() {
        return appId;
    }

    public void setAppId(Integer appId) {
        this.appId = appId;
    }

    public Integer getNotifyType() {
        return notifyType;
    }

    public void setNotifyType(Integer notifyType) {
        this.notifyType = notifyType;
    }

    public Integer getNotifyTarget() {
        return notifyTarget;
    }

    public void setNotifyTarget(Integer notifyTarget) {
        this.notifyTarget = notifyTarget;
    }

    public String getNotifyContent() {
        return notifyContent;
    }

    public void setNotifyContent(String notifyContent) {
        this.notifyContent = notifyContent;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getRetryTimes() {
        return retryTimes;
    }

    public void setRetryTimes(Integer retryTimes) {
        this.retryTimes = retryTimes;
    }

    public Long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Long createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "MonitNotifyHistory [recordId=" + recordId + ", monitId=" + monitId + ", appId=" + appId + ", notifyType=" + notifyType + ", notifyTarget="
                + notifyTarget + ", notifyContent=" + notifyContent + ", status=" + status + ", retryTimes=" + retryTimes + ", createTime=" + createTime + "]";
    }

}