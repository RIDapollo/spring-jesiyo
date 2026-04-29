import http from 'k6/http';
import { check, sleep } from 'k6';

// 1. 부하(Traffic) 설정
export const options = {
    vus: 10000,         // 100명의 가상 유저(Virtual Users)가 동시에 접속
    duration: '10s',  // 10초 동안 끊임없이 계속 요청을 보냄
};

export default function () {
    // 2. 내 톰캣 서버 주소 (포트번호 8080 등 환경에 맞게 수정)
    const url = 'http://localhost:8080/jesiyo/auction/live/bid';

    // 3. 입찰 API에 보낼 JSON 데이터 (예: 5번 경매방에 10만원 입찰 시도)
    const payload = JSON.stringify({
        auctionSeq: 21,
        bidPrice: 1000010000
    });

    // 4. HTTP 헤더 설정
    const params = {
        headers: {
            'Content-Type': 'application/json',
            // [필수] 브라우저에서 복사한 본인의 JSESSIONID를 여기에 붙여넣으세요!
            'Cookie': 'JSESSIONID=E17AA62B5CB3FD23BDAD4CF813B2A0C2' 
        },
    };

    // 5. 서버로 POST 요청 발사!
    const res = http.post(url, payload, params);

    // 6. 결과 검증: 서버가 200 OK를 잘 내려주었는가?
    check(res, {
        'status is 200': (r) => r.status === 200,
    });

    // 너무 비정상적인 폭주를 막기 위해 유저 한명당 클릭 후 0.1초의 텀을 줌
    sleep(0.1); 
}