import http from 'k6/http';
import { sleep } from 'k6';
export const options = {
  stages: [
    { duration: '10s', target: 10 },
    { duration: '25s', target: 100 },
    { duration: '25s', target: 200 },
  ],
};
export default function () {
  http.get('http://localhost:3000/qa/questions?product_id=44388');
}

//VUs are making http requests to IP clients