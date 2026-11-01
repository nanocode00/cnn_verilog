# CNN Accelerator — PyTorch Quantization ↔ Verilog RTL ↔ OpenROAD

**2-layer MNIST CNN의 소프트웨어 양자화 결과와 RTL 구현을 대조하고, 일부 RTL을 합성 친화적 구조로 수정하여 OpenROAD ASIC flow까지 검토한 3인 팀 프로젝트**입니다.

- **개인 담당:** PyTorch 양자화/HW reference 생성, SW–RTL 중간 출력 비교, synthesis-oriented RTL 수정, ModelSim·OpenROAD 검증 작업
- **기술:** PyTorch, Python, Verilog, ModelSim, OpenROAD, ASAP7
- **상세 기록:** [CNN Accelerator 개발 경험](https://github.com/nanocode00/resume/blob/main/experiences/cnn-accelerator.md) · [커밋/검증 원장](https://github.com/nanocode00/resume/blob/main/experiences/cnn-accelerator-commit-ledger.md)

## 문제와 접근

PyTorch quantized tensor의 정수·scale 표현을 RTL fixed-point 입력/가중치와 맞추고, synthesis에 적합하지 않은 parameter unpacking을 정리해야 했습니다.

1. PyTorch weight/bias 및 중간 출력의 정수 표현을 준비해 RTL 비교 기준으로 사용
2. Conv/Pool/FC 결과와 channel별 MAC 중간 출력을 확인해 값이 어긋나는 지점을 좁힘
3. 고정 파라미터 연결을 `generate`·continuous `assign` 중심의 합성 친화적 구조로 수정
4. ModelSim에서 RTL 확인 후 OpenROAD/ASAP7로 synthesis 및 physical design 단계 진행

## 보존된 소스

| 경로 | 내용 |
|---|---|
| [`chip.v`](chip.v) | CNN RTL top |
| [`conv1_layer.v`](conv1_layer.v), [`conv2_layer.v`](conv2_layer.v) | Convolution layer |
| [`maxpool_relu_1.v`](maxpool_relu_1.v), [`maxpool_relu_2.v`](maxpool_relu_2.v) | Pooling 및 활성화 |
| [`fully_connected.v`](fully_connected.v) | FC layer |
| [`modelsim/top_tb_1000.v`](modelsim/top_tb_1000.v) | MNIST 1,000장 대상 RTL testbench |
| [`data/`](data/) | 검증용 데이터 |
| [`modelsim/`](modelsim/) | 시뮬레이션/파형 설정 및 보존 로그 |
| [OpenROAD-flow-scripts Fork](https://github.com/nanocode00/OpenROAD-flow-scripts) | 별도 저장소의 OpenROAD Flow Scripts 실험 이력 |

## 결과와 한계

| 항목 | 확인 범위 |
|---|---|
| RTL simulation | **MNIST 1,000장 기준 96% 정확도** 기록 |
| Synthesis / Physical Design | synthesized Verilog와 physical design final output 생성 |
| Gate-level simulation | 정상 파형 확보 실패. **Netlist accuracy 미측정** |
| Timing closure | **실패** — 최종 STA timing violation |
| 일관된 revision 검증 | OpenROAD에 고정된 RTL SHA와 후속 시뮬레이션 RTL SHA가 달라 **동일 소스 리비전의 연속 성과로 단정 불가** |

**최종 PPA/TOPS/W, post-synthesis accuracy, 타이밍 통과를 달성했다고 주장하지 않습니다.** 96%는 소프트웨어 모델이나 Netlist의 정확도가 아니라 위 조건에서 확인한 **RTL simulation 결과**입니다. 현 저장소의 파일을 클린 환경에서 다시 실행해 동일 결과를 검증하지는 않았습니다.

## 출처와 팀 기여

이 작업은 [기존 공개 CNN RTL](https://github.com/boaaaang/CNN-Implementation-in-Verilog) 및 [OpenROAD Flow Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)를 활용했습니다. 기존 아키텍처·원본 소스 전체를 개인 단독 개발로 주장하지 않으며, 개인 수정·실험 범위는 [개발작업 원장](https://github.com/nanocode00/resume/blob/main/experiences/cnn-accelerator-commit-ledger.md)으로 확인할 수 있습니다.
