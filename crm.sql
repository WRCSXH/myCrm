/*
Navicat MySQL Data Transfer

Source Server         : MYSQL
Source Server Version : 50536
Source Host           : localhost:3306
Source Database       : crm

Target Server Type    : MYSQL
Target Server Version : 50536
File Encoding         : 65001

Date: 2020-11-18 15:38:16
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `tbl_activity`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `startDate` char(10) DEFAULT NULL,
  `endDate` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('02cd110600a44067b7795b0f6c7d2f39', '40f6cdea0bd34aceb77492a1656d9fb3', '百度推广3', '2020-10-28', '2020-11-28', '1000', '百度推广3', '2020-10-27 14:45:11', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('0383183dd1de402c832f2f327607359c', '40f6cdea0bd34aceb77492a1656d9fb3', '百度推广5', '2020-10-30', '2020-11-30', '2000', '百度推广5', '2020-10-27 14:50:08', '张三', '2020-11-02 11:43:42', '张三');
INSERT INTO `tbl_activity` VALUES ('10bf22251d374e2abcce9642a1183cea', null, '宣传发布会', null, null, null, null, null, null, null, null);
INSERT INTO `tbl_activity` VALUES ('1638829be1ef4a5c8dde8a722e774c0d', '06f5fc056eac41558a964f96daa7f27c', '百度推广2', '2020-10-27', '2020-11-27', '1000', '百度推广2', '2020-10-27 14:37:08', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('1f6f914be33d4850a797a43e1301c577', '06f5fc056eac41558a964f96daa7f27c', '聚餐1', '2020-11-01', '2020-11-01', '5000', '聚餐1', '2020-11-03 10:57:30', '张三', '2020-11-03 11:09:36', '张三');
INSERT INTO `tbl_activity` VALUES ('21f9705ed8974cecb3f84326d5159c4c', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单3', '2020-10-28', '2020-11-28', '1000', '发传单3', '2020-10-27 14:44:14', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('474c102b1dde40769a7703e51e35d797', '06f5fc056eac41558a964f96daa7f27c', '发传单2', '2020-10-27', '2020-11-27', '1000', '发传单2', '2020-10-27 14:36:25', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('923199093fd44bd588e1ac5ffee7cbe6', null, '宣传发布会', null, null, null, null, null, null, null, null);
INSERT INTO `tbl_activity` VALUES ('9c1acb5b55af44efa80b2c1ab2f57e20', null, '宣传发布会', null, null, null, null, null, null, null, null);
INSERT INTO `tbl_activity` VALUES ('a563bde4d84245b7b90142ed3e31df34', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单4', '2020-10-29', '2020-11-29', '1000', '发传单4', '2020-10-27 14:48:17', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('ab88f8d57ad848ae97c3854922b0f1c2', '06f5fc056eac41558a964f96daa7f27c', '发传单5', '2020-10-30', '2020-11-30', '1000', '发传单5', '2020-10-27 14:49:33', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('c2d85a654fbf429f92a43fbd08fcbe31', null, '宣传发布会', null, null, null, null, null, null, null, null);
INSERT INTO `tbl_activity` VALUES ('c301dff3ce3a45878f9a318ab485cc92', '40f6cdea0bd34aceb77492a1656d9fb3', '百度推广1', '2020-10-25', '2020-10-31', '10000', '百度推广1', '2020-10-25 14:42:55', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('f91b990bc9ca4163ae3bc22d1ebd6700', '06f5fc056eac41558a964f96daa7f27c', '百度推广4', '2020-10-29', '2020-11-29', '1000', '百度推广4', '2020-10-27 14:46:11', '张三', null, null);

-- ----------------------------
-- Table structure for `tbl_activity_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL COMMENT '0表示未修改，1表示已修改',
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('25886daf795f4d898a01adf6523755b2', '一般', '2020-11-05 23:47:47', '李四', '2020-11-05 23:53:21', '张三', '1', '1f6f914be33d4850a797a43e1301c577');
INSERT INTO `tbl_activity_remark` VALUES ('474ddbc0f2cf41ec819931393957467e', '真好吃', '2020-11-05 21:20:33', '张三', null, null, '0', '1f6f914be33d4850a797a43e1301c577');
INSERT INTO `tbl_activity_remark` VALUES ('88cf41b3955949c3a5e1efc61ec5217e', '我觉得不贵欸', '2020-11-06 00:04:16', '张三', '2020-11-06 00:09:22', '李四', '1', '1f6f914be33d4850a797a43e1301c577');
INSERT INTO `tbl_activity_remark` VALUES ('d101a3a90e514755a8df05c5f8577a48', '口感很差', '2020-11-06 00:16:11', '李四', '2020-11-06 00:21:08', '李四', '1', '1f6f914be33d4850a797a43e1301c577');
INSERT INTO `tbl_activity_remark` VALUES ('fa4cbfcd29064264876df8a39cc80c8b', '还不错哦', '2020-11-05 21:22:50', '李四', null, null, '0', '1f6f914be33d4850a797a43e1301c577');

-- ----------------------------
-- Table structure for `tbl_clue`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('a5f70637245f4413bdc5dab16463e383', '王健林', '先生', '40f6cdea0bd34aceb77492a1656d9fb3', '万达集团', 'CEO', 'wjl@wd.com', '010-84846002', 'www.wd.com', '12345678902', '将来联系', '广告', '张三', '2020-11-09 09:52:19', null, null, '线索2', '联系纪要2', '2020-11-12', '北京万达集团');

-- ----------------------------
-- Table structure for `tbl_clue_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clueId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('1f6f914be33d4850a797a43e1301c57d', 'a5f70637245f4413bdc5dab16463e383', 'f91b990bc9ca4163ae3bc22d1ebd6700');

-- ----------------------------
-- Table structure for `tbl_clue_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `clueId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------
INSERT INTO `tbl_clue_remark` VALUES ('c2d85a654fbf429f92a43fbd08fcbe3d', '备注4（属于王健林）', null, null, null, null, '0', 'a5f70637245f4413bdc5dab16463e383');

-- ----------------------------
-- Table structure for `tbl_contacts`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `birth` char(10) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('cf1b5dd8c4d64d0dad01e45530101d03', '40f6cdea0bd34aceb77492a1656d9fb3', '员工介绍', '65ada65e1f3945fa9d0384796a9b7cfc', '马云', '先生', 'my@alibaba.com', '12345678901', 'CEO', null, '张三', '2020-11-11 21:37:38', null, null, '线索1', '联系纪要1', '2020-11-08', '杭州阿里巴巴');

-- ----------------------------
-- Table structure for `tbl_contacts_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('77cf6e3f447648e8b2b769e4676a2586', 'cf1b5dd8c4d64d0dad01e45530101d03', '1f6f914be33d4850a797a43e1301c577');

-- ----------------------------
-- Table structure for `tbl_contacts_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('1e813c45c9d744759683265298e47866', '备注1（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', 'cf1b5dd8c4d64d0dad01e45530101d03');
INSERT INTO `tbl_contacts_remark` VALUES ('9ed9a0db94664d82b94ff65c1447d7d1', '备注2（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', 'cf1b5dd8c4d64d0dad01e45530101d03');
INSERT INTO `tbl_contacts_remark` VALUES ('b8d2562ff2cb4d619aecd9f9df4b76bd', '备注3（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', 'cf1b5dd8c4d64d0dad01e45530101d03');

-- ----------------------------
-- Table structure for `tbl_customer`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('65ada65e1f3945fa9d0384796a9b7cfc', '40f6cdea0bd34aceb77492a1656d9fb3', '阿里巴巴', 'www.alibaba.com', '010-84846001', '张三', '2020-11-11 21:37:38', null, null, '联系纪要1', '2020-11-08', '线索1', '杭州阿里巴巴');
INSERT INTO `tbl_customer` VALUES ('65ada65e1f3945fa9d0384796a9b7cfd', null, '阿里巴巴12', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('65ada65e1f3945fa9d0384796a9b7cfe', null, '阿里巴巴123', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('65ada65e1f3945fa9d0384796a9b7cff', null, '阿里巴巴12a', null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for `tbl_customer_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('3848a3b359b343968aa3628b3ec5b4f8', '备注2（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', '65ada65e1f3945fa9d0384796a9b7cfc');
INSERT INTO `tbl_customer_remark` VALUES ('45685c7784ae4296b7b563e3fd0e0892', '备注3（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', '65ada65e1f3945fa9d0384796a9b7cfc');
INSERT INTO `tbl_customer_remark` VALUES ('f3ca0d77bc7b4945a12b1b0424535eff', '备注1（属于马云）', '张三', '2020-11-11 21:37:38', null, null, '0', '65ada65e1f3945fa9d0384796a9b7cfc');

-- ----------------------------
-- Table structure for `tbl_dic_type`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '编码是主键，不能为空，不能含有中文。',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Table structure for `tbl_dic_value`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '主键，采用UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '不能为空，并且要求同一个字典类型下字典值不能重复，具有唯一性。',
  `text` varchar(255) DEFAULT NULL COMMENT '可以为空',
  `orderNo` varchar(255) DEFAULT NULL COMMENT '可以为空，但不为空的时候，要求必须是正整数',
  `typeCode` varchar(255) DEFAULT NULL COMMENT '外键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '07成交', '07成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '01资质审查', '01资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '08丢失的线索', '08丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '09因竞争丢失关闭', '09因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '02需求分析', '02需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '05提案/报价', '05提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '03价值建议', '03价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '04确定决策者', '04确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '06谈判/复审', '06谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Table structure for `tbl_tran`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('6d698974f547485b9688d0a6f77c8d98', '40f6cdea0bd34aceb77492a1656d9fb3', '1000', '双十一狂欢', '2020-11-11', '65ada65e1f3945fa9d0384796a9b7cfc', '02需求分析', '已有业务', '员工介绍', '1f6f914be33d4850a797a43e1301c577', 'cf1b5dd8c4d64d0dad01e45530101d03', '张三', '2020-11-11 21:37:38', null, null, '线索1', '联系纪要1', '2020-11-08');
INSERT INTO `tbl_tran` VALUES ('d0250bd230a743a58f0e7eabec58b9c6', '40f6cdea0bd34aceb77492a1656d9fb3', '1000000', '双十一大甩卖', '2020-11-11', '65ada65e1f3945fa9d0384796a9b7cfc', '07成交', '已有业务', '广告', '1f6f914be33d4850a797a43e1301c577', 'cf1b5dd8c4d64d0dad01e45530101d03', '张三', '2020-11-14 17:39:05', '张三', '2020-11-16 21:19:29', '线索2', '联系纪要2', '2020-11-14');

-- ----------------------------
-- Table structure for `tbl_tran_history`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) NOT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('636110db8020400cb9cf76a66c3f331f', '07成交', '1000000', '2020-11-11', '2020-11-16 21:19:29', '张三', 'd0250bd230a743a58f0e7eabec58b9c6');
INSERT INTO `tbl_tran_history` VALUES ('64ad7a6952b84528b00c685ba0d6fd1c', '09因竞争丢失关闭', '1000000', '2020-11-11', '2020-11-16 21:15:35', '张三', 'd0250bd230a743a58f0e7eabec58b9c6');

-- ----------------------------
-- Table structure for `tbl_tran_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_user`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid\r\n            ',
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `loginPwd` varchar(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据',
  `email` varchar(255) DEFAULT NULL,
  `expireTime` char(19) DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
  `lockState` char(1) DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
  `deptno` char(4) DEFAULT NULL,
  `allowIps` varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '202cb962ac59075b964b07152d234b70', 'ls@163.com', '2020-11-27 21:50:05', '1', 'A001', '192.168.1.1，127.0.0.1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '202cb962ac59075b964b07152d234b70', 'zs@qq.com', '2020-11-30 23:50:55', '1', 'A001', '192.168.1.1,192.168.1.2，127.0.0.1', '2018-11-22 11:37:34', '张三', null, null);
