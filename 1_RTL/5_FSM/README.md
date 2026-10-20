# FSM 학습·검증 (Moore 3종 + Mealy 1종)

기준: [siliconground/SoC_102의 1_RTL/6_FSM](https://github.com/siliconground/SoC_102/tree/f77f18d889530710e9d049ac8326e77cbe6f073f/1_RTL/6_FSM).
강사 저장소의 6_FSM을 이 저장소의 기존 번호인 5_FSM에 대응시켰다. 하위 디렉터리·DUT 포트·모듈명은 유지한다.
강사 예제 기반, AI 지원 수정 및 검증이다. 새 독자 설계나 실제 FPGA/합성 완료 실적으로 쓰지 않는다.
원본과 동일한 GPL v3 적용; 저장소 루트 LICENSE 참조.

## 구조와 실행

각 말단 폴더에 DUT .v / tb_*.v / Makefile이 있다. 별도 Tcl 파일이나 GUI 실행은 필요하지 않다.
.v 파일명은 수업과 맞추며, 자동 실패 판정에 사용한 $fatal을 위해 xmvlog -sv로 컴파일한다.
기존 수업의 compile → elab → sim 흐름을 유지했다. make 기본 목표는 all이고 make -j도 순차 실행한다.

```sh
cd /home/ha2012/RTL_PROJECT/1_RTL/5_FSM
make
# 개별 예제 실행
cd 1_MOORE_MACHINE/1_assign_output
make
# 다음 실행 전 생성물 정리
make clean
```

- 1_MOORE_MACHINE/1_assign_output: FSM1.v / tb_FSM1.v / Makefile
- 1_MOORE_MACHINE/2_always_output: FSM2.v / tb_FSM2.v / Makefile
- 1_MOORE_MACHINE/3_reg_output: FSM3.v / tb_FSM3.v / Makefile
- 2_MEALY_MACHINE: FSM.v / tb_FSM.v / Makefile

실행 결과는 터미널에 PASS/FAIL과 SUMMARY로 출력된다. 실패하면 $fatal로 종료하고 make도 실패해야 한다.
컴파일 DB·중간 로그는 각 build/에 모으고 Git에서 제외한다.
VCD는 build/와 해당 말단 폴더에 생성한다. 네 예제 결과는 말단 폴더의 FSM1.vcd/FSM2.vcd/FSM3.vcd/FSM.vcd이다.
make clean은 해당 예제의 build/와 그 VCD만 지운다.

나중에 그래픽 환경에서 파형을 볼 때의 명령(이번 자동 실행에는 포함하지 않음):

```sh
simvision 1_MOORE_MACHINE/1_assign_output/FSM1.vcd
```

## 원본 대비 수정 이유

1. FSM1: 다음 상태 계산이 클럭 에지 블록에 있어 state 갱신 블록과 경합할 수 있었다. always @(*) 조합 논리로 바꾸고 기본 복귀를 IDLE로 지정했다.
2. FSM2: 다음 상태/출력 조합 논리도 클럭 에지에만 반응하던 부분을 always @(*)로 바꿨다. Moore 출력은 현재 상태로 결정한다.
3. FSM3: 출력 레지스터의 case에서 rd/ds를 0으로 되돌리는 할당이 빠져 출력이 계속 유지됐다. 매 클럭 다음 상태로 두 출력을 모두 할당한다. 출력이 갱신된 상태와 맞도록 next를 사용한다.
4. Mealy: 상태 전이·출력 의미를 유지하고 조합 감지 목록을 always @(*)로 통일했다.
5. TB: 파형만 생성하는 자극에서 독립 참조 모델·비동기 reset·클럭 사이 입력 변화·전체 정상 상태 전이 검사로 확장했다. DUT 출력만 보고 기대값을 만들지 않는다.
6. Makefile: clean을 첫 기본 목표로 실행만 하던 혼동을 없애고 all을 기본으로 했다. GUI 옵션·광범위 *.lib 삭제를 사용하지 않는다.

## 핵심 개념 3개

- 상태 레지스터는 클럭에서 바뀌고, next 계산은 입력/상태가 바뀌면 다시 계산되는 조합 논리다.
- Moore 출력은 현재 상태로 결정된다. 레지스터 출력형 FSM3도 각 클럭에서 모든 출력에 값을 할당해야 한다.
- Mealy 출력은 현재 상태와 현재 입력 모두에 반응한다. 여기서는 같은 비트를 두 번 샘플한 상태에서 현재 비트도 같으면 dout_bit=1이며, 세 번째 상승 에지까지 기다리는 등록 출력이 아니다.

## 확인 범위와 다음 수업

Moore의 정상 전이 6개, Mealy의 정상 전이 10개와 reset을 검사한다. 실제 실행 수치·버전은 simulation_summary.txt 참조.
이는 RTL 기능 시뮬레이션이며 합성·타이밍·실보드 검증을 대신하지 않는다. 2_SIM/3_SYN 이후는 이번 작업에서 변경하지 않는다.
강사와 조합/순차회로의 폴더 번호 차이를 정규화한 파일 목록 비교는 RTL_COVERAGE.md 참조.
