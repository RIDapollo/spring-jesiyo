select * from member;

INSERT INTO MEMBER (SEQ, NAME, POINT, ID, PW, ADDRESS, BIRTH, NICKNAME, PERMISSION, REGDATE, PW_TOKEN, TOKEN_EXPIRY, STATUS, EMAIL_ADDRESS, LOCATION_SEQ) VALUES (member_seq.nextval, '엄준식', default, 'um1234', 'java1234', '서울시 강남구 대치동', '2000-02-03', '어떻게사람이름이엄준식', 0, DEFAULT, null, null, DEFAULT, 'um1234@test.com', null);

INSERT INTO MEMBER (SEQ, NAME, POINT, ID, PW, ADDRESS, BIRTH, NICKNAME, PERMISSION, REGDATE, PW_TOKEN, TOKEN_EXPIRY, STATUS, EMAIL_ADDRESS, LOCATION_SEQ) VALUES (member_seq.nextval, '윤진석', default, 'yun1234', 'java1234', '서울시 강남구 역삼동', '1995-04-14', '윤가놈', 0, DEFAULT, null, null, DEFAULT, 'yun1234@test.com', null);

commit;